rt_ticket_merge <- function(origin, into) {
  url <- rt_url("ticket", origin, "merge", into)
  rt_POST(url)
}