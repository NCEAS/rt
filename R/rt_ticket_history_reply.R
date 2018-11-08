#' Add ticket history reply
#'
#' Add a response to an existing ticket
#'
#' @inheritParams rt_ticket_attachment
#' @param text (character) Text that to add as a comment
#' @param cc (character) Email for cc
#' @param bcc (character) Email for bcc
#' @param time_worked (character)
#' @param attachment_path (character) Path to a file to upload
#'
#' @export
#'
#' @examples
#' \dontrun{
#' rt_ticket_history_reply(11,
#'                         "Thank you.
#'
#'                         Have a great day!")
#' }

rt_ticket_history_reply <- function(ticket_id,
                                    text,
                                    cc = NULL,
                                    bcc = NULL,
                                    time_worked = NULL, #unsure what the inputs are...
                                    attachment_path = NULL) {

  url <- rt_url("ticket", ticket_id, "comment")

  #account for NULLs
  params <- compact(list(id = ticket_id,
                         Action = "correspond",
                         Text = text,
                         CC = cc,
                         Bcc = bcc,
                         TimeWorked = time_worked,
                         Attachment = attachment_path))

  reply <- paste(names(params), params, sep = ": ", collapse = "\n")

  httr::POST(url, body = list(content = reply))

  #not tested
}
