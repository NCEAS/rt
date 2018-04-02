rt_ticket_attachment <- function(base, ticket, attachment) {
  if (missing(ticket)) {
    stop("The argument 'ticket' must be specified.", call. = FALSE)
  }

  url <- paste0(base, "/REST/1.0/ticket/", as.character(ticket), "/attachments/", as.character(attachment))

  httr::GET(url)
}
