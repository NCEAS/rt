#' Get ticket attachment
#'
#' Retrieves attachment information using the GET method.
#'
#' @param ticket_id (numeric) The ticket identifier
#' @param attachment_id (numeric) The attachment identifier
#' @param rt_base (character) The base URL that hosts RT for your organization. Set the base URL in your R session using \code{options(rt_base = "https://server.name/rt/")}
#'
#' @export
#'
#' @examples
#' \dontrun{
#' rt_ticket_attachment(12345, 56789)
#' }

rt_ticket_attachment <- function(ticket_id,
                                 attachment_id,
                                 rt_base = getOption("rt_base")) {

  url <- rt_url(rt_base, "ticket", ticket_id, "attachments", attachment_id)
  httr::GET(url)
}
