#' \code{rt} package
#'
#' Request Tracker R API
#'
#' See \href{https://github.com/NCEAS/rt}{GitHub}
#'
#' @docType package
#' @name rt
#' @importFrom dplyr %>%
#' @import httr
#'
NULL

if(getRversion() >= "2.1.15") {
  utils::globalVariables(c(".",
                           "type", "Attachments", #for rt_ticket_attachments
                           "colname", "value", "ticket_headers", "ticket_content",
                           "fields", "values", # for search
                           "history_id", "history_name", # for history
                           "id", "attachment_id", "attachment_name", "type_general", "type_specific", "size", "blank")) #attachment
}