stop_for_status <- function(status) {
  if (status < 200 || status >= 300) {
    stop(status)
  }
}