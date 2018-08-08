#' Get ticket properties
#'
#' Retrieves ticket properties
#'
#' @param ticket_id (numeric) The ticket identifier
#' @param rt_base (character) The base URL that hosts RT for your organization. Set the base URL in your R session using \code{options(rt_base = "https://server.name/rt/")}
#'
#' @export
#'
#' @examples
#' \dontrun{
#' rt_ticket_properties(15)
#' }

rt_ticket <- function(ticket_id, rt_base = getOption("rt_base")) {
  url <- rt_url(rt_base, "ticket", ticket_id, "show")
  rt_GET(url)
}
