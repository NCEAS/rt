#' Get queue properties
#'
#' Get the data for a single queue.
#'
#' @param queue (character) The queue
#' @inheritParams rt_login
#'
#' @export
#'
#' @examples
#' \dontrun{
#' rt_queue_properties("General")
#' }

rt_queue_properties <- function(queue, rt_base_url = Sys.getenv("RT_BASE_URL")) {
  stopifnot(is.character(queue))
  url <- rt_url(rt_base_url, "queue", queue)
  rt_GET(url)
}
