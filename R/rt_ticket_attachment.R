#' Get ticket attachment
#'
#' Retrieves attachment metadata
#'
#' @param ticket_id (numeric) The ticket identifier
#' @param attachment_id (numeric) The attachment identifier
#' @inheritParams rt_login
#'
#' @family attachments
#'
#' @export
#'
#' @examples
#' \dontrun{
#' rt_ticket_attachment(2, 1)
#' }

rt_ticket_attachment <- function(ticket_id,
                                 attachment_id,
                                 rt_base = getOption("rt_base")) {

  url <- rt_url(rt_base, "ticket", ticket_id, "attachments", attachment_id)
  rt_GET(url)

  #TODO: parse more?  currently Content & Headers catches stuff that could be split out further
}
