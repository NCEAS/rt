rt_login <- function(base, user, pass) {
  req <- httr::POST(base, body = list('user' = user, 'pass' = pass))
  if (req$status_code == 200) {
    message("Successfully logged in.")
  } else {
    stop(req)
  }

  invisible(TRUE)
}

