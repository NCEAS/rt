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
                           "colname", "value", "ticket_headers", "ticket_content",
                           "fields", "values")) # for search
}