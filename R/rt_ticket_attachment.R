#' Get ticket attachment
#'
#' Retrieves attachment metadata
#'
#' @param ticket_id (numeric) The ticket identifier
#' @param attachment_id (numeric) The attachment identifier
#' @inheritParams rt_login
#'
#' @export
#'
#' @examples
#' \dontrun{
#' rt_ticket_attachment(2, 1)
#' }

rt_ticket_attachment <- function(ticket_id,
                                 attachment_id) {

  url <- rt_url("ticket", ticket_id, "attachments", attachment_id)
  rt_GET(url)
}
