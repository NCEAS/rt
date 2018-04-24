#' Log in to RT
#'
#' Use this to log into RT at the start of your session.
#'
#' @param base (character) The base URL that hosts RT for your organization
#' @param user (character) Your username
#' @param pass (character) Your password
#'
#' @export
#'
#' @import httr
#' @import stringr
#'
#' @examples
#' \dontrun{
#' rt_login("https://server.name/rt/", "my_username", "my_password")
#' }

rt_login <- function(base, user, pass) {
  base_api <- paste(stringr::str_replace(base, "\\/$", ""), # removes trailing slash from base URL just in case
                "REST", "1.0", sep = "/")
  req <- httr::POST(base_api, body = list('user' = user, 'pass' = pass))

  # Check that login worked
  # Try getting a ticket
  test_ticket <- httr::GET(paste(base_api, "ticket", 00000, sep = "/"))
  if(stringr::str_detect(test_ticket, "Credentials required")){
    message("Your log-in was unsuccessful. Please try again.")
    invisible(FALSE)
  } else {
    message("Successfully logged in.")
    invisible(TRUE)
  }
}

#' Log in to RT interactively
#'
#' Wrapper for \code{\link{rt_login}} to interactively log into RT at the start of your
#' session. Keeps your log-in information private.
#'
#' @param base (character) The base URL that hosts RT for your organization
#'
#' @import getPass
#'
#' @export
#'
#' @examples
#' \dontrun{
#' rt_login_interactive("https://server.name/rt/")
#' }

rt_login_interactive <- function(base) {
  rt_login(base = base,
           user = readline("Enter username: "),
           pass = getPass::getPass())
}
