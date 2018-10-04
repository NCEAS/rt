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
                                 attachment_id,
                                 rt_base_url = Sys.getenv("RT_BASE_URL")) {

  url <- rt_url(rt_base_url, "ticket", ticket_id, "attachments", attachment_id, "content")
  httr::GET(url)
  #parse more? may be best to leave as is
}
