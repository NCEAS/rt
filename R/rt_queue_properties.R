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

rt_queue_properties <- function(queue) {
  stopifnot(is.character(queue))
  url <- rt_url("queue", queue)
  response <- rt_GET(url)

  parse_rt_properties(response$body)
}

