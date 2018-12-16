#' The \code{rt} package
#'
#' \code{rt} provides a programming interface to the
#' \href{https://rt-wiki.bestpractical.com/wiki/REST}{Request Tracker API}.
#'
#' Everything should be implemented and all functions should return a reasonably
#' useful result that's suitable for programming with.
#'
#' See \href{https://github.com/NCEAS/rt}{GitHub} for more information.
#'
#' @docType package
#' @name rt
#' @importFrom dplyr %>%
#'
NULL

if (getRversion() >= "2.1.15") {
  utils::globalVariables(c(".",
                           "type", "Attachments", #for rt_ticket_attachments
                           "colname", "value", "ticket_headers", "ticket_content",
                           "fields", "values", # for search
                           "history_id", "history_name", # for history
                           "id", "attachment_id", "attachment_name", "type_general", "type_specific", "size", "blank")) #attachment
}
