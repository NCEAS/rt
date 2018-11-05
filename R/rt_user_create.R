#' Create new user
#'
#' Add a new RT user
#'
#' @param user_id (numeric) The user identifier
#' @param password (character) The password
#' @param name (character) Optional. User name
#' @param email_address (character) Optional. User email
#' @param real_name (character) Optional. User real name
#' @param organization (character) Optional. User organization
#' @param privileged (numeric) Optional. User privilege status
#' @param disabled (numeric) Optional. User disabled status
#' @inheritParams rt_ticket_attachment
#'
#' @export
#'
#' @examples
#' \dontrun{
#' rt_user_create()
#' }

rt_user_create <- function(user_id,
                           password,
                           name = NULL,
                           email_address = NULL,
                           real_name = NULL,
                           organization = NULL,
                           privileged = NULL,
                           disabled = NULL,
                           rt_base_url = Sys.getenv("RT_BASE_URL")) {

  params <- compact(list(Name = name,
                         Password = password,
                         EmailAddress = email_address,
                         RealName = real_name,
                         Organization = organization,
                         Privileged = privileged,
                         Disabled = disabled))

  user_info <- paste(names(params), params, sep = ": ", collapse = "\n")

  url <- rt_url("user", "new")
  httr::POST(url, body = list(content = user_info))
  #TODO: make this work!
  #might need specific permissions?
}
