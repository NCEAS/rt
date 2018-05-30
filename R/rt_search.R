#' Search RT
#'
#' Search RT for tickets that fit your query.
#'
#' @param query (character) A query
#' @param orderBy (character) How to order your search results
#' @param format (character) Either \code{i} (ticket ID only),
#' \code{s} (ticket ID and title), or \code{l} (full ticket metadata).
#' Defaults to \code{l}.
#' @param rt_base (character) The base URL that hosts RT for your organization. Set the base URL in your R session using \code{options(rt_base = "https://server.name/rt/")}
#'
#' @export
#'
#' @importFrom tidyr unnest separate spread
#' @import dplyr
#' @importFrom tibble tibble
#' @import stringr
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
  l <- plyr::compact(list(query = query,
                     orderBy = orderBy,
                     format = format))

  params <- paste(paste0(names(l), "=", l), collapse = "&")

  url <- paste0(base_api, "/search/ticket?", params)



  req <- httr::GET(URLencode(url))

  if (stringr::str_detect(httr::content(req), "Bad request")) {
    stop(httr::content(req), call. = FALSE)
  }

  if (format != "l") {
    return(req)
  }

  not_empty <- function(column) {
    !all(column == "" | is.na(column))
  }

  result <- tibble::tibble(content = stringr::str_split(httr::content(req), "\\n--\\n")[[1]]) %>%
    dplyr::mutate(content = stringr::str_split(content, "\\n"),
                  line = 1:n()) %>%
    tidyr::unnest() %>%
    dplyr::filter(content != "") %>%
    tidyr::separate(content, c("colname", "value"), sep = ":", fill = "right", extra = "merge") %>%
    tidyr::spread(colname, value) %>%
    dplyr::select_if(not_empty)

  return(result)
}

