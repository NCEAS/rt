#' Get ticket attachments
#'
#' Retrieves attachment metadata using the GET method.
#'
#' @param ticket_id (numeric) The ticket identifier
#' @param rt_base (character) The base URL that hosts RT for your organization. Set the base URL in your R session using \code{options(rt_base = "https://server.name/rt/")}
#'
#' @export
#'
#' @examples
#' \dontrun{
#' rt_ticket_attachments(12345)
#' }

rt_ticket_attachments <- function(ticket_id,
                                   rt_base = getOption("rt_base")) {

  url <- rt_url(rt_base, "ticket", ticket_id, "attachments")

  httr::GET(url)
}
