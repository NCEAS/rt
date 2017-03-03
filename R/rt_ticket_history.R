rt_ticket_history <- function(base, ticket) {
  if (missing(ticket)) {
    stop("'ticket' must be specified.", call. = FALSE)
  }

  url <- paste0(base, "/ticket/", as.character(ticket), "/history")

  req <- httr::GET(url)
  history <- stringr::str_split(httr::content(req), "\\n")[[1]]
  history <- Filter(function(x) { stringr::str_detect(x, ":")}, history)
  transactions <- stringr::str_split(history, ": ")
  ids <- lapply(transactions, function(x) x[1])
  bodies <- lapply(transactions, function(x) x[2])

  transactions_df <- data.frame(id = unlist(ids), body = unlist(bodies), stringsAsFactors = FALSE)
  transactions_df <- transactions_df[order(transactions_df$id),]

  transactions_df
}