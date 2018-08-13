#' Get RT user properties
#'
#' Gets the ticket links for a single ticket. If applicable, the following fields will be returned: \code{HasMember},
#' \code{ReferredToBy}, \code{DependedOnBy}, \code{MemberOf}, \code{RefersTo}, and \code{DependsOn}.
#'
#' @inheritParams rt_user_create
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
