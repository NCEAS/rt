#' Parse an RT response in its parts as a list
#'
#' The RT API uses overrides default HTTP behavior with their own set of status
#' codes, messages, and response formats. This function parses that custom
#' implementation and presents it into something that's easier to build a
#' package with.
#'
#' For example, a response like:
#'
#' "RT/4.4.3 200 Ok
#'
#' # Ticket 2 created.
#'
#' "
#'
#' is turned into the list:
#'
#' $status
#' [1] 200
#'
#' $message
#' [1] "Ok"
#'
#' $body
#' [1] "# Ticket 2 created."
#'
#' @param response (character) Parsed response from \code{\link[httr]{content}}
#' @param verbose (logical) Optional, defaults to \code{TRUE}.
#'   Prints more information during parsing.
#'
#' @return (list) List with named elements status, message, and body
rt_parse_response <- function(response, verbose = FALSE) {
  body <- suppressWarnings(httr::content(response))

  split_response <- stringr::str_split(body, "[\\n]+", n = 2)

  # Response should be a single result, with parts for the first line, and rest
  if (length(split_response) != 1 ||
      length(split_response[[1]]) != 2) {
    message("Failed to parse RT response. Returning response directly from httr.")
    return(response)
  }

  first <- split_response[[1]][1]
  rest <- stringr::str_replace_all(split_response[[1]][2], "[\\n]+$", "")

  # Parse the first line (RT version + HTTP status + custom status messsage)
  match <- stringr::str_match(first, "\\ART/[\\d\\.]+ (\\d+) (.+)\\Z")

  # Stop, helpfully, if we failed to get what we expected from the regex
  if (!all(dim(match) == c(1, 3))) {
    if (verbose) {
      message(content)
    }

    message("Failed to parse RT response. Returning response directly from httr.")
    return(response)
  }

  structure(
    list(
      path = response$url,
      status = as.numeric(match[1,2]),
      message = match[1,3],
      body = gsub("^#[ ]+", "", rest)
    ),
    class = "rt_api"
  )
}