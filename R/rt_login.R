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
#' @examples
#' \dontrun{
#' rt_login("https://support.nceas.ucsb.edu/rt/", "my_username", "my_password")
#' }

rt_login <- function(base, user, pass) {
  req <- httr::POST(rt_url(base), body = list('user' = user, 'pass' = pass))

  # Process RT's strange custom status code
  status_match <- str_match_all(content(req), "RT\\/[\\d\\.]+ (\\d+).+")

  if (length(status_match) != 1 && all(dim(status_match[[1]]) != c(1, 2))) {
    stop(call. = FALSE, "Failed to parse response from RT.")
  }

  status_code <- as.numeric(status_match[[1]][,2])

  if (status_code == 200) {
    message("Successfully logged in.")
  } else {
    stop(req)
  }

  invisible(TRUE)
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
#' rt_login_interactive("https://support.nceas.ucsb.edu/rt/")
#' }

rt_login_interactive <- function(base,
                                 username = readline("Enter username: ") ,
                                 password = getPass::getPass()) {
  rt_login(base = base,
           user = username,
           pass = password)
}
