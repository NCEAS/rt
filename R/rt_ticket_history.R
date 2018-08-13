#' Get ticket history
#'
#' Retrieves information about the ticket history
#'
#' @inheritParams rt_ticket_attachment
#' @param format (character) Either  \code{s} (ticket ID and subject)
#' or \code{l} (full ticket metadata).
#' Defaults to \code{l}.
#'
#' @export
#'
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
#' rt_ticket_history(992)
#' #'
#' # Get just the ticket ID and subject
#' rt_ticket_history(992, format = "s")
#' }

rt_ticket_history <- function(ticket_id, format = "l", rt_base = getOption("rt_base")) {
  if (missing(ticket_id)) {
    stop("'ticket_id' must be specified.", call. = FALSE)
  }

  url <- rt_url(rt_base, "ticket", ticket_id, "history")
  if(format == "l"){
    url <- paste0(url, "?format=l")
  }

  out <- rt_GET(url)

  if(format == "s"){
    out$content <- out$content %>%
      tidyr::gather(history_id, history_name)
  }

  return(out)

#   if(format == "l"){
#     history <- stringr::str_split(content(req), "\\n\\n--\\n\\n")[[1]]
#     print(cat(history))
#   } else {
#     history <- tibble::tibble(content = stringr::str_split(httr::content(req), "\\n")[[1]]) %>%
#       dplyr::filter(str_detect(content, ":")) %>%
#       tidyr::separate(content, c("ticket", "subject"), sep = ": ", extra = "merge")
#   }
#
#   return(history)
}
