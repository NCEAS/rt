#' Get a ticket's attachments
#'
#' Retrieves attachment metadata for a ticket in a tabular form.
#'
#' @inheritParams rt_ticket_attachment
#' @param ... Other arguments passed to \code{\link{rt_POST}}
#'
#' @return Either a `data.frame` or `tibble` of the attachments.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # Given a ticket exists with id '2', we can get its attachments as a table
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

  result <- lapply(attachments, function(attachment) {
    props <- as.list(
      stringr::str_match(
        attachment,
        "\\(?(.+)\\) \\((.+) \\/ (.+)\\)")[1, (2:4)]
    )

    names(props) <- c("Name", "Type", "Size")
    props
  })

  if (length(result) == 0) {
    return(try_tibble(data.frame()))
  }

  try_tibble(
    cbind(data.frame(id = names(result), stringsAsFactors = FALSE),
          do.call(rbind, lapply(result, function(x) {
            data.frame(x, stringsAsFactors = FALSE)
          }))
    )
  )
}
