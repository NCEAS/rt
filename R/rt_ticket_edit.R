#' Edit an RT ticket
#'
#' Update an existing ticket with new information.
#'
#' @param ticket_id (numeric|character) The ticket number
#' @param queue (character) Queue name
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
#' @param rt_base (character) The base URL that hosts RT for your organization. Set the base URL in your R session using \code{options(rt_base = "https://server.name/rt/")}
#'
#' @export
#'
#' @examples
#' \dontrun{
#' rt_ticket_edit(20, priority = 2, custom_field = c(Description = "A description"))
#' }

rt_ticket_edit <- function(ticket_id,
                           queue = NULL,
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
                           rt_base = getOption("rt_base")) {
  stopifnot(is.character(ticket_id) | is.numeric(ticket_id))

  params <- compact(list(id = ticket_id,
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

  ticket_content <- paste(names(params), params, sep = ": ", collapse = "\n")

  if(exists("custom_field") && length(custom_field) > 0){
    cf <- sprintf("CF-%s: %s", names(custom_field), custom_field)
    ticket_content <- paste(ticket_content, cf)
  }

  url <- rt_url(rt_base, "ticket", ticket_id, "edit")
  httr::POST(url, body = list(content = ticket_content))

  #need to check
}
