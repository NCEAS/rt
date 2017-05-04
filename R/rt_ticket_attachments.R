rt_ticket_attachments <- function(base, ticket) {
  if (missing(ticket)) {
    stop("The argument 'ticket' must be specified.", call. = FALSE)
  }

  url <- paste0(base, "/REST/1.0/ticket/", as.character(ticket), "/attachments")

  httr::GET(url)
}
