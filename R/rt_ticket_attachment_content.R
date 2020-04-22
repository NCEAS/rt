#' Get the content of an attachment
#'
#' Gets the content of the specified attachment for further processing or
#' manipulation. You'll almost always want to call a second function like
#' \code{\link[httr]{content}} to make the content of the
#' attachment usable from R.
#'
#' @inheritParams rt_ticket_attachment
#' @param ... Other arguments passed to \code{\link{rt_GET}}
#'
#' @return (rt_api) An `rt_api` object with the response
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # First, get the attachment content which gives is the raw response
#' att <- rt_ticket_attachment_content(2, 1)
#'
#' # Then process it directly in R
#' httr::content(att)
#'
#' # Or write it to disk
#' out_path <- tempfile()
#' writeBin(httr::content(x, as = 'raw'), out_path)
#' }
rt_ticket_attachment_content <- function(ticket_id,
                                         attachment_id,
                                         ...) {
  url <- rt_url("ticket", ticket_id, "attachments", attachment_id, "content")
  response <- rt_GET(url, raw = TRUE, ...)
  stopforstatus(response)

  response
}
