#' Get ticket attachments
#'
#' Retrieves attachment metadata for a ticket
#'
#' @inheritParams rt_ticket_attachment
#'
#' @export
#'
#' @examples
#' \dontrun{
#' rt_ticket_attachments(2)
#' }

rt_ticket_attachments <- function(ticket_id,
                                   rt_base_url = Sys.getenv("RT_BASE_URL")) {
  url <- rt_url(rt_base_url, "ticket", ticket_id, "attachments")
  out <- rt_GET(url)

  #TODO: test how robust this is:
  out$content <- out$content %>%
    dplyr::mutate(Attachments = stringr::str_split(Attachments, ",\n             ")) %>%
    tidyr::unnest(Attachments) %>%
    tidyr::separate(Attachments, c("attachment_id", "attachment_name", "type_general", "type_specific", "size", "blank"),
                    sep = "[^[:alnum:].]+", fill = "right") %>%
    mutate(type = paste(type_general, type_specific, sep = "/")) %>%
    select(attachment_id, attachment_name, type, size)

  return(out)
}


