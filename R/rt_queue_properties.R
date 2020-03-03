#' Get the properties of a queue
#'
#' @param queue (character) The queue
#' @param ... Other arguments passed to \code{\link{rt_GET}}
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # By default, RT installations come with a General queue
#' # We can get its properties like this
#' rt_queue_properties("General")
#' }
rt_queue_properties <- function(queue, ...) {
  stopifnot(is.character(queue))
  url <- rt_url("queue", queue)
  response <- rt_GET(url, ...)

  # Handle queue not found
  if (stringr::str_detect(response$body, "No queue named")) {
    stop("No queue named ", queue, " exists.", call. = FALSE)
  }

  stopforstatus(response)

  parse_rt_properties(response$body)
}
