#' Add ticket history comment
#'
#' Add a comment to an existing ticket
#'
#' @inheritParams rt_ticket_attachment
#' @param comment_text (character) Text that to add as a comment
#' @param ... Other arguments passed to \code{\link{rt_POST}}
#'
#' @export
#'
#' @examples
#' \dontrun{
#' rt_ticket_history_comment(1, "Your comment here...")
#' }

rt_ticket_history_comment <- function(ticket_id, comment_text, ...) {
  url <- rt_url("ticket", ticket_id, "comment")

  comment <- sprintf("id: %s\nAction: comment\nText: %s",
                     ticket_id,
                     comment_text)

  httr::POST(url, body = list(content = comment), ...)

  #' TODO: implement attachment
  #' https://rt-wiki.bestpractical.com/wiki/REST#Ticket_History_Comment
}
