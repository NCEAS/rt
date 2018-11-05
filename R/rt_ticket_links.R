#' Get RT ticket links
#'
#' Gets the ticket links for a single ticket. If applicable, the following fields will be returned: \code{HasMember},
#' \code{ReferredToBy}, \code{DependedOnBy}, \code{MemberOf}, \code{RefersTo}, and \code{DependsOn}.
#'
#' @inheritParams rt_ticket_attachment
#'
#' @export
#'
#' @examples
#' \dontrun{
#' rt_ticket_links(1007)
#' }

rt_ticket_links <- function(ticket_id) {
  stopifnot(is.character(ticket_id) | is.numeric(ticket_id))

  url <- rt_url("ticket", ticket_id, "links", "show")

  rt_GET(url)
}
