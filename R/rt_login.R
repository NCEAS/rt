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
#' @param rt_base_url (character) The address of your RT installation.
#'   See details.
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
#' # Or if you prefer, you can pass the values directly, like
#' rt_login("user", "password", "https://demo.bestpractical.com")
#'}
rt_login <- function(user = Sys.getenv("RT_USER"),
                     password = Sys.getenv("RT_PASSWORD"),
                     ...) {
  url <- rt_url()
  response <- rt_POST(url,
                      body = list(
                        'user' = utils::URLencode(user,
                                                  reserved = TRUE),
                        'pass' = utils::URLencode(password,
                                                  reserved = TRUE)),
                      ...)
  check_login(response)
}

#' Check that the login request was successful or not
#'
#' @param response (httr::response) RT API login response
#'
#' @return (logical) TRUE if login was succesful, errors out otherwise
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
#' Wrapper for \code{\link{rt_login}} to interactively log into RT at the start of your
#' session. Keeps your log-in information private.
#'
#' @param rt_base_url (character) The base URL that hosts RT for your organization. Set the base URL in your R session using \code{Sys.getenv("RT_BASE_URL" = "https://server.name/rt/")}
#'
#' @importFrom getPass getPass
#'
#' @export
#'
#' @examples
#' \dontrun{
#' Sys.setenv(RT_BASE_URL = "https://demo.bestpractical.com")
#' rt_login_interactive()
#' }

rt_login_interactive <- function(rt_base_url = Sys.getenv("RT_BASE")) {
  rt_login(user = readline("Enter username: "),
           password = getPass::getPass(),
           rt_base_url = rt_base_url)
}
