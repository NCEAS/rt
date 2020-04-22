#' Get a ticket's attachment
#'
#' Retrieves attachment metadata. To get the attachment itself, see
#' \link{rt_ticket_attachment_content}.
#'
#' @param ticket_id (numeric) The ticket identifier
#' @param attachment_id (numeric) The attachment identifier
#' @param ... Other arguments passed to \code{\link{rt_GET}}
#'
#' @return (rt_api) An `rt_api` object with the response
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # Before running rt_ticket_attachment, you'll probably want to get a list of
#' # the attachments for a given ticket, like:
#' attachments <- rt_ticket_attachments(1) # Ticket ID 1
#'
#' # And then you can get information about a specific attachment:
#' rt_ticket_attachment(1, 3) # Attachment 3 on ticket 1
#' }
rt_ticket_attachment <- function(ticket_id,
                                 attachment_id,
                                 ...) {
  url <- rt_url("ticket", ticket_id, "attachments", attachment_id)
  response <- rt_GET(url, ...)
  stopforstatus(response)

  if (grepl("Ticket \\d+ does not exist", response$body)) {
    stop(response$body)
  }

  if (grepl("^Invalid attachment id:", response$body)) {
    stop(response$body)
  }

  response
}
