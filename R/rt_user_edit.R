#' Edit user information
#'
#' Add a comment to an existing ticket
#'
#' @param user_id (numeric) The user identifier
#' @param password (character) The password
#' @param name (character) Optional. User name
#' @param email_address (character) Optional. User email
#' @param real_name (character) Optional. User real name
#' @param organization (character) Optional. User organization
#' @param privileged (numeric) Optional. User privilege status
#' @param disabled (numeric) Optional. User disabled status
#' @param rt_base (character) The base URL that hosts RT for your organization. Set the base URL in your R session using \code{options(rt_base = "https://server.name/rt/")}
#'
#' @export
#'
#' @examples
#' \dontrun{
#' rt_user_create()
#' }

rt_user_edit <- function(user_id,
                         password,
                         name = NULL,
                         email_address = NULL,
                         real_name = NULL,
                         organization = NULL,
                         privileged = NULL,
                         disabled = NULL,
                         rt_base = getOption("rt_base")) {

  params <- compact(list(Name = name,
                         Password = password,
                         EmailAddress = email_address,
                         RealName = real_name,
                         Organization = organization,
                         Privileged = privileged,
                         Disabled = disabled))
  #HasMember is invalid here but used in rt_ticket_links

  user_info <- paste(names(params), params, sep = ": ", collapse = "\n")

  url <- rt_url(rt_base, "user", "27", "edit")
  httr::POST(url, body = list(content = user_info))
  #TODO: make this work!
  #might need specific permissions?
  #got Permission denied error
}