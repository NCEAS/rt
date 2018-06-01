#' Add ticket history reply
#'
#' Add a response to an existing ticket
#'
#' @param ticket_id (numeric) The ticket identifier
#' @param reply_text (character) Text that to add as a comment
#' @param rt_base (character) The base URL that hosts RT for your organization. Set the base URL in your R session using \code{options(rt_base = "https://server.name/rt/")}
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
                                    reply_text,
                                    cc = NULL,
                                    bcc = NULL,
                                    time_worked = NULL,
                                    attachment_path = NULL,
                                    rt_base = getOption("rt_base")) {

  url <- rt_url(rt_base, "ticket", ticket_id, "comment")

  #account for NULLs
  params <- purrr::compact(list(id = ticket_id,
                                Action = "correspond",
                                Text = reply_text,
                                CC = cc,
                                Bcc = bcc,
                                TimeWorked = time_worked,
                                Attachment = attachment_path))

  reply <- paste(names(params), params, sep = ": ", collapse = "\n")

  httr::POST(url, body = list(content = reply))

  #not tested
}

rt_ticket_history_reply(11,
                        "Thank you.

                        Have a great day!")
