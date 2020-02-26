#' The test suite runs only unit tests by default.
#' Most of the useful tests are integration tests that rely on having a test
#' instance of RT to make requests to.
#'
#' For ease of use, a Docker run command is listed in the README for launching
#' a local instance of RT and the test suite is configured to make requests
#' to it.
#'
#' To all of the tests to run, uncomment the next line:
# Sys.setenv("RT_INTEGRATION" = TRUE)

# Log us in if we're not on CRAN and we're running integration tests
if (!testthat:::on_cran() && Sys.getenv("RT_INTEGRATION") == TRUE) {
  Sys.setenv(RT_BASE_URL = "http://localhost",
             RT_USER = "root",
             RT_PASSWORD = "password")
  rt_login()
}

# Skip helper to control whether integration tests are run or not
skip_unless_integration <- function() {
  testthat::skip_if(Sys.getenv("RT_INTEGRATION") != TRUE)
}
