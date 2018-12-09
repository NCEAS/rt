#' Get ticket history
#'
#' Retrieves information about the ticket history
#'
#' @inheritParams rt_ticket_attachment
#' @param format (character) The format of the ticket history response. Either
#'   \code{s} (ticket ID and subject) or \code{l} (full ticket metadata).
#'   Defaults to \code{l}.
#' @param ... Other arguments passed to \code{\link{rt_GET}}
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # Get the full ticket history
#' rt_ticket_history(992)
#'
#' # Get just the ticket ID and subject
#' rt_ticket_history(992, format = "s")
#' }

rt_ticket_history <- function(ticket_id, format = "l", ...) {
  if (missing(ticket_id)) {
    stop("'ticket_id' must be specified.", call. = FALSE)
  }

  url <- rt_url("ticket",
                ticket_id,
                "history",
                query_params = list(format = format))

  #' TODO: Improve parsing here. I'm not sure what the most useful return value
  #' is though.
  rt_GET(url, ...)
}
