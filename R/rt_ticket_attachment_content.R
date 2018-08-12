#' Get ticket attachment content
#'
#' Retrieves attachment content
#'
#' @inheritParams rt_ticket_attachment
#'
#' @family attachments
#'
#' @export
#'
#' @examples
#' \dontrun{
#' rt_ticket_attachment_content(2, 1)
#' }

rt_ticket_attachment_content <- function(ticket_id,
                                 attachment_id,
                                 rt_base = getOption("rt_base")) {

  url <- rt_url(rt_base, "ticket", ticket_id, "attachments", attachment_id, "content")
  httr::GET(url)
  #parse more? may be best to leave as is
}
