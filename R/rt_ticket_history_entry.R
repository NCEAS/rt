#' Gets the history information for a single history item
#'
#' @inheritParams rt_ticket_attachment
#' @param history_id (numeric) The history entry identifier
#' @param ... Other arguments passed to \code{\link{rt_GET}}
#'
#' @return (rt_api) An `rt_api` object with the response
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # Get the history entry for ticket 992 and history id 123
#' rt_ticket_history(992, 123)
#' }
rt_ticket_history_entry <- function(ticket_id, history_id, ...) {
  url <- rt_url("ticket",
                ticket_id,
                "history/id",
                history_id)

  response <- rt_GET(url, ...)
  stopforstatus(response)

  parse_rt_properties(response$body)
}
