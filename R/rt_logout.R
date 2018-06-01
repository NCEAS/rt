#' Log out of RT
#'
#' Use this to log out of RT at the end of your session.  Note: restarting your R session will also log you out.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' rt_logout()
#' }

rt_logout <- function(rt_base = getOption("rt_base")) {
  url <- rt_url(rt_base, "logout")
  httr::POST(url, body = NULL)
  #clean output?
}
