#' Log in to RT
#'
#' Use this to log into RT at the start of your session. Once you call this
#' function and successfully log in, calls of other functions within this
#' package will re-use your login information automatically.
#'
#' The value of \code{rt_base_url} should be the same address you use in your
#' web browser to log into RT (i.e., the address of the log in page).
#'
#' @param user (character) Your username.
#' @param password (character) Your password.
#' @param ... Other arguments passed to \code{\link{rt_POST}}
#'
#' @return Either `TRUE`, invisibly, if logged in, or throws an error.
#' @export
#'
#' @examples
#' \dontrun{
#' # You can setup the location of your RT installation and the values for
#' # your credentials as environmental variables
#' Sys.setenv("RT_USER" = "user",
#'            "RT_PASSWORD" = "password",
#'            "RT_BASE_URL" = "https://demo.bestpractical.com")
#'
#' # And then log in directly like
#' rt_login()
#'
#' # You can also skip setting `RT_USER` and `RT_PASSWORD` and specify them
#' # directly
#' rt_login("user", "password")
#' # Note that you still need to set `RT_BASE_URL`
#'}
rt_login <- function(user = Sys.getenv("RT_USER"),
                     password = Sys.getenv("RT_PASSWORD"),
                     ...) {
  if ((user == "" || password == "") && interactive()) {
    rt_login_interactive(...)
  } else {
    rt_do_login(user, password)
  }
}

#' Actually do the logging in part of logging in
#'
#' Called by \code{\link{rt_login}} and \code{\link{rt_login_interactive}} to
#' do the work of logging in
#'
#' @param user (character) Your username.
#' @param password (character) Your password.
#' @param ... Other arguments passed to \code{\link{rt_POST}}
#'
#' @return (logical) Either returns \code{TRUE} if successful or errors out
rt_do_login <- function(user, password, ...) {
  url <- rt_url()
  response <- rt_POST(url,
                      body = list(
                      "user" = user,
                      "pass" = password),
                      ...)
  result <- check_login(response)
  stopforstatus(response)

  invisible(result)
}

#' Check that the login request was successful or not
#'
#' @param response (httr::response) RT API login response
#'
#' @return (logical) TRUE if login was successful, errors out otherwise
check_login <- function(response) {
  if (response$body != "Invalid object specification: ''\n\nid: ") {
    stop("Login failed: ", response$message, " (", response$body, ")",
         call. = FALSE)
  }

  message("Successfully logged in.")
  invisible(TRUE)
}

#' Log in to RT interactively
#'
#' Wrapper for \code{\link{rt_login}} to interactively log into RT at the start
#' of your session. Keeps your log-in information private.
#'
#' @param rt_base_url (character) The base URL that hosts RT for your
#' organization. Set the base URL in your R session using
#' \code{Sys.getenv("RT_BASE_URL" = "https://server.name/rt/")}
#' @param ... Other arguments passed to \code{\link{rt_do_login}}
#'
#' @export
#'
#' @examples
#' \dontrun{
#' Sys.setenv(RT_BASE_URL = "https://demo.bestpractical.com")
#' rt_login_interactive()
#' }
rt_login_interactive <- function(rt_base_url = Sys.getenv("RT_BASE"), ...) {
  if (!requireNamespace("askpass")) {
    stop(call. = FALSE,
         paste(
           "The 'askpass' is required when enter your password interactively.",
           'Install it with install.packages("askpass").',
           "\nYou can also set your password with",
           'Sys.getenv(RT_PASSWORD="your password").',
           "See ?rt for more details."))
  }

  rt_do_login(user = trimws(readline("Enter username: ")),
              password = trimws(askpass::askpass()),
              rt_base_url = rt_base_url,
              ...)
}
