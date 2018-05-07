#' Get ticket history
#'
#' Retrieves attachment information using the GET method.
#'
#'
#' @param ticket (numeric) The ticket identifier
#' @param format (character) Either  \code{s} (ticket ID and subject)
#' or \code{l} (full ticket metadata).
#' Defaults to \code{l}.
#' @param rt_base (character) The base URL that hosts RT for your organization. Set the base URL in your R session using \code{options(rt_base = "https://server.name/rt/")}
#'
#' @export
#'
#' @importFrom httr GET
#' @import stringr
#' @importFrom tidyr separate
#' @import dplyr
#' @importFrom tibble tibble
#'
#' @examples
#' \dontrun{
#' # Log in to RT
#' options(rt_base = "https://demo.bestpractical.com")
#' rt_login(user = "guest", pass = "guest")
#'
#' # Get the full ticket history
#' history_l <- rt_ticket_history(990)
#' # View the first correspondence/comment; use cat() to display the formatting
#' cat(history_l[1])
#'
#' # Get just the ticket ID and subject
#' rt_ticket_history(990, format = "s")
#' }

rt_ticket_history <- function(ticket, format = "l", rt_base = getOption("rt_base")) {
  if (missing(ticket)) {
    stop("'ticket' must be specified.", call. = FALSE)
  }

  url <- paste0(rt_base, "/REST/1.0/ticket/", as.character(ticket), "/history")
  if(format == "l"){
    url <- paste0(url, "?format=l")
  }

  req <- httr::GET(url)

  if(format == "l"){
    history <- stringr::str_split(content(req), "\\n\\n--\\n\\n")[[1]]
    print(cat(history))
  } else {
    history <- tibble::tibble(content = stringr::str_split(httr::content(req), "\\n")[[1]]) %>%
      dplyr::filter(str_detect(content, ":")) %>%
      tidyr::separate(content, c("ticket", "subject"), sep = ": ", extra = "merge")
  }

  return(history)
}