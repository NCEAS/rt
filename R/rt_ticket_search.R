#' Search RT
#'
#' Search RT for tickets using RT's query syntax. Queries are specified using RT's custom syntax which you can read about at \url{https://docs.bestpractical.com/rt/4.4.3/query_builder.html}.
#'
#' @param query (character) Your query (See Details)
#' @param orderby (character) How to order your search results. Should be a
#' ticket property name preceeded by either a + or a - character.
#' @param format (character) Either \code{i} (ticket ID only),
#' \code{s} (ticket ID and subject), or \code{l} (full ticket metadata).
#' Defaults to \code{l}.
#' @param fields (character) Comma-separated list of fields to include in the
#' results.
#' @param ... Other arguments passed to \code{\link{rt_GET}}
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # To return all un-owned tickets on a queue:
#' rt_ticket_search("Queue='General' AND (Status='new')")
#' rt_ticket_search("Queue='General' AND (Status='new')",
#'                  orderBy = "+Created")
#' }
rt_ticket_search <- function(query,
                             orderby = NULL,
                             format="l",
                             fields = NULL,
                             ...) {
  if (!(format %in% c("l", "s", "i"))) {
      stop(call. = FALSE,
           "Invalid choice of format, '",
           format,
           "'. Valid options are l (long), s (short), or i.")
  }

  params <- list(query = query,
                 orderby = orderby,
                 format = format,
                 fields = fields)

  url <- rt_url("search", "ticket", query_params = params)
  response <- rt_GET(url, ...)

  # Handle bad request. Not sure how comprehensive this is.
  if (response$status >= 400) {
    stop(response)
  }

  if (format == "s") {
    result <- lapply(
      strsplit(response$body, "\\n")[[1]],
      parse_rt_properties)
  } else if (format == "i") {
    result <- stringr::str_split(response$body, "\n")[[1]]
  } else if (format == "l" ) {
    result <- lapply(
      strsplit(response$body, "\\n\\n--\\n\\n")[[1]],
      parse_rt_properties)
  }

  result
}



