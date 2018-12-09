#' Get RT user properties
#'
#' @param user_id (numeric) The ID of the User to edit
#' @param ... Other arguments passed to \code{\link{rt_GET}}
#' @export
#'
#' @examples
#' \dontrun{
#' rt_user_properties(1)
#' }

rt_user_properties <- function(user_id, ...) {
  stopifnot(is.character(user_id) | is.numeric(user_id))

  url <- rt_url("user", user_id)
  response <- rt_GET(url, ...)

  if (stringr::str_detect(response$body, "does not exist")) {
    stop("User ", user_id, " does not exist.", call. = FALSE)
  }

  parse_rt_properties(response$body)
}
