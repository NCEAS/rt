rt_ticket_show <- function(base, ticket) {
  if (missing(ticket)) {
    stop("The argument 'ticket' must be specified.", call. = FALSE)
  }

  url <- paste0(base, "/ticket/", as.character(ticket), "/show")

  httr::GET(url)
}
