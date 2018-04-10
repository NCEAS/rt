#' Get ticket attachments
#'
#' Retrieves attachment metadata using the GET method.
#'
#' @param base 
#' @param ticket 
#'
#' @return
#' @export
#' 
#' @importFrom httr GET
#'
#' @examples
#' \dontrun{
#' rt_ticket_attachments("https://server.name/rt/", "12345")
#' }

rt_ticket_attachments <- function(base, ticket) {
  if (missing(ticket)) {
    stop("The argument 'ticket' must be specified.", call. = FALSE)
  }

  url <- paste0(base, "/REST/1.0/ticket/", as.character(ticket), "/attachments")

  httr::GET(url)
}
