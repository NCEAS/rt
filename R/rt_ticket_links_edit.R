#' Edit an RT ticket link
#'
#' Update links of an existing RT ticket.
#'
#' @param ticket_id (numeric|character) The ticket identifier
#' @param referred_to_by Tickets that are referred to
#' @param depended_on_by Tickets that are depended on
#' @param member_of Ticket groups?
#' @param refers_to Tickets that are referred to
#' @param depends_on Tickets that are depended on
#' @param rt_base (character) The base URL that hosts RT for your organization. Set the base URL in your R session using \code{options(rt_base = "https://server.name/rt/")}
#'
#' @export
#'
#' @examples
#' \dontrun{
#' rt_ticket_edit(20, "Priority: 2")
#' }
#'

rt_ticket_links_edit <- function(ticket_id,
                                 referred_to_by = NULL, depended_on_by = NULL,
                                 member_of = NULL, refers_to = NULL, depends_on = NULL,
                                 rt_base = getOption("rt_base")) {
  stopifnot(is.character(ticket_id) | is.numeric(ticket_id))

  params <- compact(list(ReferredToBy = referred_to_by,
                         DependedOnBy = depended_on_by,
                         MemberOf = member_of,
                         RefersTo = refers_to,
                         DependsOn = depends_on))
  #HasMember is invalid here but used in rt_ticket_links

  links_edit <- paste(names(params), params, sep = ": ", collapse = "\n")

  url <- rt_url(rt_base, "ticket", ticket_id, "links")
  httr::POST(url, body = list(content = links_edit))
}
