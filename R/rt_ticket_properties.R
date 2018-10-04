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

rt_ticket_properties <- function(ticket_id, rt_base_url = Sys.getenv("RT_BASE_URL")) {
  url <- rt_url(rt_base_url, "ticket", ticket_id, "show")
  rt_GET(url)
}
