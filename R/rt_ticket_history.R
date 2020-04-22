#' Get a ticket's history
#'
#' @inheritParams rt_ticket_attachment
#' @param format (character) The format of the ticket history response. Either
#'   \code{s} (ticket ID and subject) or \code{l} (full ticket metadata).
#'   Defaults to \code{l}.
#' @param ... Other arguments passed to \code{\link{rt_GET}}
#'
#' @return (rt_api) An `rt_api` object with the response
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # Get the full ticket history for ticket 992
#' rt_ticket_history(992)
#'
#' # Get just the ticket ID and subject for ticket 992
#' rt_ticket_history(992, format = "s")
#' }
rt_ticket_history <- function(ticket_id, format = "l", ...) {
  url <- rt_url("ticket",
                ticket_id,
                "history",
                query_params = list(format = format))

  response <- rt_GET(url, ...)
  stopforstatus(response)

  response
}
