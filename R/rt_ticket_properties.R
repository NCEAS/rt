#' Get a ticket's properties
#'
#' Retrieves ticket properties
#'
#' @inheritParams rt_ticket_attachment
#' @param ... Other arguments passed to \code{\link{rt_GET}}
#'
#' @export
#'
#' @examples
#' \dontrun{
#' rt_ticket_properties(15)
#' }
rt_ticket_properties <- function(ticket_id, ...) {
  url <- rt_url("ticket", ticket_id, "show")
  response <- rt_GET(url, ...)

  if (grepl("Ticket \\d+ does not exist\\.", response$body)) {
    stop(response$body)
  }

  stopforstatus(response)

  parse_rt_properties(response$body)
}
