#' Generate an RT API URL
#'
#' Create an RT API URL based on the server URL and any arguments provided
#'
#' @param base (character) The base URL that hosts RT for your organization
#' @param ... Other parameters
#'

rt_url <- function(base, ...) {
  paste(gsub("\\/$", "", base), # Removes trailing slash from base URL just in case
        "REST", "1.0",
        paste(c(...), collapse = "/"),
        sep = "/")
}

#' Compact list.
#'
#' Remove all NULL entries from a list. From \code{plyr::compact()}.
#'
#' @param l list
compact <- function(l) Filter(Negate(is.null), l)
