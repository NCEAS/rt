#' Edit an RT ticket link
#'
#' Update links of an existing RT ticket.
#'
#' @inheritParams rt_ticket_attachment
#' @param referred_to_by Tickets that are referred to
#' @param depended_on_by Tickets that are depended on
#' @param member_of Ticket groups?
#' @param refers_to Tickets that are referred to
#' @param depends_on Tickets that are depended on
#' @param ... Other arguments passed to \code{\link{rt_POST}}
#'
#' @export
#'
#' @examples
#' \dontrun{
#' rt_ticket_edit(20, "Priority: 2")
#' }
#'

rt_ticket_links_edit <- function(ticket_id,
                                 referred_to_by = NULL,
                                 depended_on_by = NULL,
                                 member_of = NULL,
                                 refers_to = NULL,
                                 depends_on = NULL,
                                 ...) {
  stopifnot(is.character(ticket_id) | is.numeric(ticket_id))

  # HasMember is invalid here but used in rt_ticket_links
  params <- compact(list(ReferredToBy = referred_to_by,
                         DependedOnBy = depended_on_by,
                         MemberOf = member_of,
                         RefersTo = refers_to,
                         DependsOn = depends_on))

  links_edit <- paste(names(params), params, sep = ": ", collapse = "\n")

  url <- rt_url("ticket", ticket_id, "links")
  httr::POST(url, body = list(content = links_edit), ...)
}
