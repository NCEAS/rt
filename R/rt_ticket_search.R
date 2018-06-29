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
#'
#' @examples
#' \dontrun{
#' # To return all un-owned tickets on a queue:
#' rt_ticket_search(query = "Queue='General'AND(Status='new')")
#' }

rt_ticket_search <- function(query, orderBy = NULL, format="l", rt_base = getOption("rt_base")) {
  base_api <- rt_url(rt_base, "search", "ticket?")

  #based on httr::modify_url()
  #possible TODO - turn this into its own function that can be used internally in the package
  inputs <- compact(list(query = utils::URLencode(query, reserved = TRUE),
                         orderBy = orderBy,
                         format = format))

  params <- paste(paste0(names(inputs), "=", inputs), collapse = "&")

  url <- paste0(base_api, params)

  out <- rt_GET(url)

  if(format == "s"){
    out$content <- out$content %>%
      tidyr::gather(id, value)
  }

  if(format == "i"){
    out$content <- out$content %>%
      stringr::str_split("\n")
  }

  return(out)

  # if (stringr::str_detect(httr::content(req), "Bad request")) {
  #   stop(httr::content(req), call. = FALSE)
  # }
  #
  # if (format != "l") {
  #   return(req)
  # } else {
  #   result <- tibble::tibble(content = stringr::str_split(httr::content(req), "\\n--\\n")[[1]]) %>%
  #     mutate(line = 1:n(),
  #            content = lapply(content, tabularize_ticket)) %>%
  #     tidyr::unnest() %>%
  #     tidyr::spread(ticket_headers, ticket_content) %>%
  #     dplyr::select_if(function(column) {!all(column == "" | is.na(column))}) #not empty
  #
  #   return(result)
  # }
}
