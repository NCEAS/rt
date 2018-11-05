#' Get ticket attachment content
#'
#' Retrieves attachment content
#'
#' @inheritParams rt_ticket_attachment
#'
#' @export
#'
#' @examples
#' \dontrun{
#' rt_ticket_attachment_content(2, 1)
#' }

rt_ticket_attachment_content <- function(ticket_id,
                                         attachment_id) {

  url <- rt_url("ticket", ticket_id, "attachments", attachment_id, "content")
  rt_GET(url)
}
