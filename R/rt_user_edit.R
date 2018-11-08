#' Edit user information
#'
#' Add a comment to an existing ticket
#'
#' @inheritParams rt_user_create
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
                         disabled = NULL) {

  params <- compact(list(Name = name,
                         Password = password,
                         EmailAddress = email_address,
                         RealName = real_name,
                         Organization = organization,
                         Privileged = privileged,
                         Disabled = disabled))
  #HasMember is invalid here but used in rt_ticket_links

  user_info <- paste(names(params), params, sep = ": ", collapse = "\n")

  url <- rt_url("user", "27", "edit")
  httr::POST(url, body = list(content = user_info), httr::user_agent("https://github.com/nceas/rt"))
  #TODO: make this work!
  #might need specific permissions?
  #got Permission denied error
}
