#' Get a ticket's links
#'
#' Gets the ticket links for a single ticket. If applicable, the following
#' fields will be returned: \code{HasMember},
#' \code{ReferredToBy}, \code{DependedOnBy}, \code{MemberOf}, \code{RefersTo},
#' and \code{DependsOn}.
#'
#' @inheritParams rt_ticket_attachment
#' @param ... Other arguments passed to \code{\link{rt_GET}}
#'
#' @return (rt_api) An `rt_api` object with the response
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # Assuming have a ticket with id 1007, we can get it links by calling
#' rt_ticket_links(1007)
#' }
rt_ticket_links <- function(ticket_id, ...) {
  stopifnot(is.character(ticket_id) || is.numeric(ticket_id))

  url <- rt_url("ticket", ticket_id, "links", "show")

  response <- rt_GET(url, ...)
  stopforstatus(response)

  if (grepl("Ticket \\d+ does not exist", response$body)) {
    stop(response$body)
  }

  response
}
