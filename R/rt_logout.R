#' Log out of RT
#'
#' Use this to log out of RT at the end of your session.
#' Note: restarting your R session will also log you out.
#'
#' @param ... Other arguments passed to \code{\link{rt_POST}}
#'
#' @export
#'
#' @examples
#' \dontrun{
#' rt_logout()
#' }

rt_logout <- function(...) {
  url <- rt_url("logout")
  response <- rt_POST(url, body = NULL)

  if (response$message == "Credentials required") {
    stop("Can't log out: You aren't logged in.", call. = FALSE)
  }

  stopforstatus(response)

  message("You are now logged out.")
  invisible(response)
}
