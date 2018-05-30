tabularize_ticket <- function(text) {
  # Helper function to help tabularize ticket text from search results
  ticket_headers <- stringr::str_extract_all(text, "\\n[a-zA-Z0-9{}.]+:")[[1]] %>%
    str_replace_all("\\n|:", "")
  ticket_content <- stringr::str_split(text, "\\n[a-zA-Z0-9{}.]+:")[[1]][-1] %>%
    trimws()

  return(data.frame(ticket_headers, ticket_content, stringsAsFactors = FALSE))
}

#' Search RT
#'
#' Search RT for tickets that fit your query.
#'
#' @param query (character) A query
#' @param orderBy (character) How to order your search results
#' @param format (character) Either \code{i} (ticket ID only),
#' \code{s} (ticket ID and subject), or \code{l} (full ticket metadata).
#' Defaults to \code{l}.
#' @param rt_base (character) The base URL that hosts RT for your organization. Set the base URL in your R session using \code{options(rt_base = "https://server.name/rt/")}
#'
#' @export
#'
#' @importFrom tidyr unnest separate spread
#' @import dplyr
#' @importFrom tibble tibble
#' @import stringr
#' @importFrom utils URLencode
#' @importFrom plyr compact
#'
#' @examples
#' \dontrun{
#' # To return all un-owned tickets on a queue:
#' rt_search(query = "Queue='some_queue'AND(Owner='Nobody')")
#' }

rt_search <- function(query, orderBy = NULL, format="l", rt_base = getOption("rt_base")) {
  base_api <- paste(stringr::str_replace(rt_base, "\\/$", ""), # removes trailing slash from base URL just in case
                    "REST", "1.0", sep = "/")

  #based on httr::modify_url()
  #possible TODO - turn this into its own function that can be used internally in the package
  l <- plyr::compact(list(query = query,
                     orderBy = orderBy,
                     format = format))

  params <- paste(paste0(names(l), "=", l), collapse = "&")

  url <- paste0(base_api, "/search/ticket?", params)

  req <- httr::GET(utils::URLencode(url))

  if (stringr::str_detect(httr::content(req), "Bad request")) {
    stop(httr::content(req), call. = FALSE)
  }

  if (format != "l") {
    return(req)
  }

  result <- tibble::tibble(content = stringr::str_split(httr::content(req), "\\n--\\n")[[1]]) %>%
    mutate(line = 1:n(),
           content = lapply(content, tabularize_ticket)) %>%
    tidyr::unnest() %>%
    tidyr::spread(ticket_headers, ticket_content) %>%
    dplyr::select_if(function(column) {!all(column == "" | is.na(column))}) #not empty

  return(result)
}


