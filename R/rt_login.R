rt_login <- function(base, user, pass) {
  req <- httr::POST(paste0(base, "/REST/1.0/"), body = list('user' = user, 'pass' = pass))
  if (req$status_code == 200) {
    message("Successfully logged in.")
  } else {
    stop(req)
  }

  invisible(TRUE)
}

