#' Get ticket history
#'
#' Retrieves attachment information using the GET method.
#'
#' @param base (character) The base URL that hosts RT for your organization
#' @param ticket (numeric) The ticket identifier
#'
#' @export
#' 
#' @importFrom httr GET
#' @import stringr
#'
#' @examples
#' \dontrun{
#' rt_ticket_history("https://server.name/rt/", 12345)
#' }

rt_ticket_history <- function(base, ticket) {
  if (missing(ticket)) {
    stop("'ticket' must be specified.", call. = FALSE)
  }

  url <- paste0(base, "/REST/1.0/ticket/", as.character(ticket), "/history")

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