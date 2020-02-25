#' Parse an RT ticket create response body and return the ticket ID
#'
#' This function essential parses the text:
#' `"# Ticket 1 created."`
#' @param body (character) The ticket create response body
#'
#' @return (numeric) The ticket ID
parse_ticket_create_body <- function(body) {
  match_result <- stringr::str_match(body, "Ticket (\\d+) created\\.")

    if (is.na(match_result[1,1])) {
    stop(body, call. = FALSE)
  }

  as.numeric(match_result[1,2])
}

#' Create an RT ticket
#'
#' Create a new ticket in RT.
#'
#' @inheritParams rt_queue_properties
#' @param requestor (character) Requestor email address
#' @param subject (character) Ticket subject
#' @param cc (character) Email address to cc
#' @param admin_cc (character) Admin email address to cc
#' @param owner (character) Owner username or email
#' @param status (character) Ticket status; typically "open", "new", "stalled", or "resolved"
#' @param priority (numeric) Ticket priority
#' @param initial_priority (numeric) Ticket initial priority
#' @param final_priority (numeric) Ticket final priority
#' @param time_estimated (character) Time estimated ?????
#' @param starts (character) Starts ?????
#' @param due (character) Due date ?????
#' @param text (character) Ticket content; if multi-line, prefix every line with a blank
#' @param custom_field (vector) Takes a named vector of the custom field name and custom field value
#' @inheritParams rt_login
#' @param ... Other arguments passed to \code{\link{rt_POST}}

#'
#' @export
#'
#' @examples
#' \dontrun{
#' rt_ticket_create(priority = 2, custom_field = c(Description = "A description"))
#' }
rt_ticket_create <- function(queue = NULL,
                             requestor = NULL,
                             subject = NULL,
                             cc = NULL,
                             admin_cc = NULL,
                             owner = NULL,
                             status = NULL,
                             priority = NULL,
                             initial_priority = NULL,
                             final_priority = NULL,
                             time_estimated = NULL,
                             starts = NULL,
                             due = NULL,
                             text = NULL,
                             custom_field = NULL,
                             ...) {
  params <- compact(list(id = "ticket/new",
                         Queue = queue,
                         Requestor = requestor,
                         Subject = subject,
                         Cc = cc,
                         AdminCc = admin_cc,
                         Owner = owner,
                         Status = status,
                         Priority = priority,
                         InitialPriority = initial_priority,
                         FinalPriority = final_priority,
                         TimeEstimated = time_estimated,
                         Starts = starts,
                         Due = due,
                         Text = text))

  ticket_content <- construct_newline_pairs(params)

  if (exists("custom_field") && length(custom_field) > 0) {
    cf <- sprintf("\nCF-%s: %s", names(custom_field), custom_field)
    ticket_content <- paste(ticket_content, cf)
  }

  url <- rt_url("ticket", "new")
  response <- rt_POST(url, body = list(content = ticket_content), ...)

  parsed <- parse_ticket_create_body(response$body)
  stopforstatus(response)

  parsed
}
