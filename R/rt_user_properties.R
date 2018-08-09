#' Get RT user properties
#'
#' Gets the ticket links for a single ticket. If applicable, the following fields will be returned: \code{HasMember},
#' \code{ReferredToBy}, \code{DependedOnBy}, \code{MemberOf}, \code{RefersTo}, and \code{DependsOn}.
#'
#' @param user_id (numeric|character) The user id or login.
#' @param rt_base (character) The base URL that hosts RT for your organization. Set the base URL in your R session using \code{options(rt_base = "https://server.name/rt/")}
#'
#' @export
#'
#' @examples
#' \dontrun{
#' rt_user_properties(1)
#' }

rt_user_properties <- function(user_id, rt_base = getOption("rt_base")) {
  stopifnot(is.character(user_id) | is.numeric(user_id))

  url <- rt_url(rt_base, "user", user_id)

  rt_GET(url)
}
