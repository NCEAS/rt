#' Get ticket attachment content
#'
#' Retrieves attachment content
#'
#' @inheritParams rt_ticket_attachment
#' @param ... Other arguments passed to \code{\link{rt_GET}}
#'
#' @export
#'
#' @examples
#' \dontrun{
#' rt_ticket_attachment_content(2, 1)
#' }
rt_ticket_attachment_content <- function(ticket_id,
                                         attachment_id,
                                         ...) {
  url <- rt_url("ticket", ticket_id, "attachments", attachment_id, "content")
  response <- rt_GET(url, ...)
  stopforstatus(response)

  response
}
