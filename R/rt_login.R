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