#' Search RT
#'
#' Search RT for tickets using RT's query syntax. Queries are specified using RT's custom syntax which you can read about at \url{https://docs.bestpractical.com/rt/4.4.3/query_builder.html}.
#'
#' @param query (character) Your query (See Details)
#' @param orderBy (character) How to order your search results
#' @param format (character) Either \code{i} (ticket ID only),
#' \code{s} (ticket ID and subject), or \code{l} (full ticket metadata).
#' Defaults to \code{l}.
#' @inheritParams rt_ticket_attachment
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # To return all un-owned tickets on a queue:
#' rt_ticket_search(query = "Queue='General' AND (Status='new')")
#' }

rt_ticket_search <- function(query, orderBy = NULL, format="l", rt_base = getOption("rt_base")) {
  base_api <- rt_url(rt_base, "search", "ticket?")

  #based on httr::modify_url()
  #possible TODO - turn this into its own function that can be used internally in the package
  inputs <- compact(list(query = utils::URLencode(query, reserved = TRUE),
                         orderBy = orderBy,
                         format = format))

  params <- paste(paste0(names(inputs), "=", inputs), collapse = "&")
  url <- paste0(base_api, params)
  out <- rt_GET(url)

  if (format == "s") {
    out$content <- out$content %>%
      tidyr::gather(id, value)
  }

  if (format == "i") {
    out$content <- out$content %>%
      stringr::str_split("\n")
  }

  return(out)
}
