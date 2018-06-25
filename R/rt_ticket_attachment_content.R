#' Get ticket attachment content
#'
#' Retrieves attachment content
#'
#' @param ticket_id (numeric) The ticket identifier
#' @param attachment_id (numeric) The attachment identifier
#' @param rt_base (character) The base URL that hosts RT for your organization. Set the base URL in your R session using \code{options(rt_base = "https://server.name/rt/")}
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
