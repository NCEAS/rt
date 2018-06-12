#' Add ticket history comment
#'
#' Add a comment to an existing ticket
#'
#' @param ticket_id (numeric) The ticket identifier
#' @param comment_text (character) Text that to add as a comment
#' @param rt_base (character) The base URL that hosts RT for your organization. Set the base URL in your R session using \code{options(rt_base = "https://server.name/rt/")}
#'
#' @export
#'
#' @examples
#' \dontrun{
#' rt_ticket_history_comment()
#' }

rt_ticket_history_comment <- function(ticket_id, comment_text, rt_base = getOption("rt_base")) {

  url <- rt_url(rt_base, "ticket", ticket_id, "comment")

  comment <- sprintf("id: %s\nAction: comment\nText: %s",
                     ticket_id, comment_text)

  httr::POST(url, body = list(content = comment))

  #implement attachment
  #https://rt-wiki.bestpractical.com/wiki/REST#Ticket_History_Comment
}