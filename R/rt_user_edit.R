#' Warn if a user edit response body contains warnings
#'
#' @param body (character)
#'
#' @return None.
warn_user_edit_warnings <- function(body) {
  parts <- stringr::str_split(body, "\n# User \\d+ updated\\.")

  # Hackily validate the result here
  if (length(parts) == 1 &&
      length(parts[[1]]) == 2 &&
      stringr::str_detect(parts[[1]][1], ": ")) {
    warning(parts[[1]][1])
  }
}

#' Edit user information
#'
#' @param user_id (numeric) The ID of the User to edit
#' @inheritParams rt_user_create
#' @param ... Other arguments passed to \code{\link{rt_POST}}
#'
#' @export
#'
#' @examples
#' \dontrun{
#' rt_user_create()
#' }

rt_user_edit <- function(user_id,
                         password = NULL,
                         name = NULL,
                         email_address = NULL,
                         real_name = NULL,
                         organization = NULL,
                         privileged = NULL,
                         disabled = NULL,
                         ...) {

  params <- compact(list(Name = name,
                         Password = password,
                         EmailAddress = email_address,
                         RealName = real_name,
                         Organization = organization,
                         Privileged = privileged,
                         Disabled = disabled))

  user_info <- paste(names(params), params, sep = ": ", collapse = "\n")

  url <- rt_url("user", user_id, "edit")
  response <- rt_POST(url, body = list(content = user_info), ...)

  # I'm not sure how to make this fail so we we just return TRUE invisibly when
  # it succeeds
  if (stringr::str_detect(response$body, "User \\d+ updated\\.")) {
    # RT returns warnings just prior to the User X updated. message so let's
    # bubble these out to the user.
    # e.g., "EmailAddress: Email address in use\n# User 461 updated.\n\n"...
    warn_user_edit_warnings(response$body)

    return(invisible(TRUE))
  }

  stop("Failed to edit user ", user_id, ".\n\n", response$body)
}
