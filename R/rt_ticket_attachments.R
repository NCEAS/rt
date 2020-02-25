#' Get ticket attachments
#'
#' Retrieves attachment metadata for a ticket
#'
#' @inheritParams rt_ticket_attachment
#' @param ... Other arguments passed to \code{\link{rt_POST}}
#'
#' @export
#'
#' @examples
#' \dontrun{
#' rt_ticket_attachments(2)
#' }
rt_ticket_attachments <- function(ticket_id, ...) {
  url <- rt_url("ticket", ticket_id, "attachments")
  out <- rt_GET(url, ...)
  stopforstatus(out)

  location <- stringr::str_locate(out$body, "Attachments: ")

  if (all(dim(location) != c(1, 2))) {
    stop("Error while processing response from RT.")
  }

  rest <- stringr::str_sub(out$body, location[1, 2] + 1, nchar(out$body))
  attachments <- parse_rt_properties(rest)

  lapply(attachments, function(attachment) {
    props <- as.list(
      stringr::str_match(
        attachment,
        "\\(?(.+)\\) \\((.+) \\/ (.+)\\)")[1, (2:4)]
    )

    names(props) <- c("Name", "Type", "Size")
    props
  })
}
