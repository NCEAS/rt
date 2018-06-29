#' Get RT ticket links
#'
#' Gets the ticket links for a single ticket. If applicable, the following fields will be returned: \code{HasMember},
#' \code{ReferredToBy}, \code{DependedOnBy}, \code{MemberOf}, \code{RefersTo}, and \code{DependsOn}.
#'
#' @param ticket_id (numeric|character) The ticket number
#' @param rt_base (character) The base URL that hosts RT for your organization. Set the base URL in your R session using \code{options(rt_base = "https://server.name/rt/")}
#'
#' @export
#'
#' @examples
#' \dontrun{
#' rt_ticket_links(1007)
#' }

rt_ticket_links <- function(ticket_id, rt_base = getOption("rt_base")) {
  stopifnot(is.character(ticket_id) | is.numeric(ticket_id))

  url <- rt_url(rt_base, "ticket", ticket_id, "links", "show")

  rt_GET(url)
}
