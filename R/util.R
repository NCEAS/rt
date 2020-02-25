#' Throw an error if the RT status code is an error status
#'
#' @param response (response) An `httr` response object
#'
#' @return Either nothing, or throws an error
stopforstatus <- function(response) {
  if (response$status >= 400) {
    stop(response$message)
  }
}
