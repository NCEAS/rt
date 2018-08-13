#' Get ticket properties
#'
#' Retrieves ticket properties
#'
#' @inheritParams rt_ticket_attachment
#'
#' @export
#'
#' @examples
#' \dontrun{
#' rt_ticket_properties(15)
#' }

rt_ticket_properties <- function(ticket_id, rt_base = getOption("rt_base")) {
  url <- rt_url(rt_base, "ticket", ticket_id, "show")
  rt_GET(url)
}
