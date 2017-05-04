#' Generate an RT API URL
#'
#' @param base
#' @param ...
#'
#' @return
rt_url <- function(base, ...) {
  paste(gsub("\\/$", "", base), # Removes trailing slash from base URL just in case
        "REST",
        "1.0",
        paste(c(...),
              collapse = "/"),
        sep = "/")
}
