#' Get queue properties
#'
#' Get the data for a single queue.
#'
#' @param queue_id (character) The queue identifier
#' @inheritParams rt_login
#'
#' @export
#'
#' @examples
#' \dontrun{
#' rt_queue_properties("General")
#' }

rt_queue_properties <- function(queue_id, rt_base = getOption("rt_base")) {
  stopifnot(is.character(queue_id))
  url <- rt_url(rt_base, "queue", queue_id)
  rt_GET(url)
}
