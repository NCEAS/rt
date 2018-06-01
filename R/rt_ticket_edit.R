#' Edit an RT ticket
#'
#' Update an existing ticket with new information.
#'
#' @param ticket_id (numeric|character) The ticket number
#'
#' @export
#'
#' @examples
#' \dontrun{
#' rt_ticket_edit(20, "Priority: 2")
#' }

rt_ticket_edit <- function(ticket_id, changes, rt_base = getOption("rt_base")) {
  stopifnot(is.character(ticket_id) | is.numeric(ticket_id))

  url <- rt_url(rt_base, "ticket", ticket_id, "edit")
  httr::POST(url, body = list(content = changes))
  #clean output?
  #TODO: add to vignettes
}
