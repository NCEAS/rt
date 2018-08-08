#' Get queue properties
#'
#' Get the data for a single queue.
#'
#' @param queue_id (character) The queue identifier
#' @param rt_base (character) The base URL that hosts RT for your organization. Set the base URL in your R session using \code{options(rt_base = "https://server.name/rt/")}
#'
#' @export
#'
#' @examples
#' \dontrun{
#' rt_queue_properties("General")
#' }

rt_queue <- function(queue_id, rt_base = getOption("rt_base")) {
  stopifnot(is.character(queue_id))
  url <- rt_url(rt_base, "queue", queue_id)
  rt_GET(url)
}
