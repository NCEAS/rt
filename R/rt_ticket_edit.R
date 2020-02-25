#' Edit an RT ticket
#'
#' Update an existing ticket with new information.
#'
#' @param ticket_id (numeric|character) The ticket number
#' @inheritParams rt_ticket_create
#' @param ... Other arguments passed to \code{\link{rt_POST}}

#' @export
#'
#' @examples
#' \dontrun{
#' rt_ticket_edit(20,
#'                priority = 2,
#'                custom_field = c(Description = "A description"))
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
                           ...) {
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

  ticket_content <- construct_newline_pairs(params)

  if (exists("custom_field") && length(custom_field) > 0) {
    cf <- sprintf("CF-%s: %s", names(custom_field), custom_field)
    ticket_content <- paste(ticket_content, cf)
  }

  url <- rt_url("ticket", ticket_id, "edit")
  response <- rt_POST(url, body = list(content = ticket_content), ...)
  stopforstatus(response)

  response
}
