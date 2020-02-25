#' Try to make a tibble
#'
#' @param df (data.frame) The `data.frame` to try attempt to coerce to a
#' `tibble`
#' @param coerce (logical) Whether or not to try coercion. Provided for upstream
#' calling functions.
#'
#' @return Either a `data.frame` or a `tibble`
try_tibble <- function(df, coerce = TRUE) {
  if (!coerce) {
    return(df)
  }

  if (!requireNamespace("tibble")) {
    return(df)
  }

  tibble::as_tibble(df)
}

#' tidy_long_search_result
#'
#' @param result (list) List of lists from search results
#' @param coerce_tibble (logical) Whether or not to try to coerce the result to
#' a `tibble`.
#'
#' @return A `data.frame` or `tbl_df`
tidy_long_search_result <- function(result, coerce_tibble = TRUE) {
  if (length(result) == 1 && names(result[[1]]) == "No matching results.") {
    return(try_tibble(data.frame(), coerce_tibble))
  }

  # Turn into a list of data.frames with cleaner names
  dfs <- lapply(result, function(r) {
    rdf <- data.frame(t(unlist(r)), stringsAsFactors = FALSE)

    # Remove spaces and periods from names
    names(rdf) <- gsub("[ \\.]*", "", names(rdf))

    rdf
  })

  all_dfs <- do.call(rbind.data.frame, dfs)

  # Remove "ticket/" from `id` column since ids should always be numbers
  all_dfs$id <- gsub("ticket/", "", all_dfs$id)

  try_tibble(all_dfs)
}

#' Search RT
#'
#' Search RT for tickets using RT's query syntax which is documented at
#' \url{https://docs.bestpractical.com/rt/4.4.3/query_builder.html}.
#'
#' @param query (character) Your query (See Details)
#' @param orderby (character) How to order your search results. Should be a
#' ticket property name preceeded by either a + or a - character.
#' @param format (character) Either \code{i} (ticket ID only),
#' \code{s} (ticket ID and subject), or \code{l} (full ticket metadata).
#' Defaults to \code{l}.
#' @param fields (character) Comma-separated list of fields to include in the
#' results.
#' @param coerce_tibble (logical) Whether or not to make the result when
#' `format` is `l` or `s` into a `tibble`. Defaults to `TRUE` and only works
#' when the `tibble` package is installed.
#' @param ... Other arguments passed to \code{\link{rt_GET}}
#'
#' @return Either a data.frame/tibble (when format is `l` or `s`) or a numeric
#' vector when its `i`.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # To return all un-owned tickets on a queue:
#' rt_ticket_search("Queue='General' AND (Status='new')")
#'
#' # We can sort by date created, increasing
#' rt_ticket_search("Queue='General' AND (Status='new')",
#'                  orderby = "+Created")
#'
#' # If we just need a vector of ticket ids
#' rt_ticket_search("Queue='General' AND (Status='new')",
#'                  orderby = "+Created",
#'                  format = "i")
#' }
rt_ticket_search <- function(query,
                             orderby = NULL,
                             format = "l",
                             fields = NULL,
                             coerce_tibble = TRUE,
                             ...) {
  if (!(format %in% c("l", "s", "i"))) {
      stop(call. = FALSE,
           "Invalid choice of format, '",
           format,
           "'. Valid options are l (long), s (short), or i.")
  }

  params <- list(query = query,
                 orderby = orderby,
                 format = format,
                 fields = fields)

  url <- rt_url("search", "ticket", query_params = params)
  response <- rt_GET(url, ...)

  # Handle bad request. Not sure how comprehensive this is.
  if (response$status >= 400) {
    stop(response)
  }

  if (format == "s") {
    result <- lapply(
      strsplit(response$body, "\\n")[[1]],
      parse_rt_properties)

    # Special behavior to handle RT returning zero results
    if (length(result) == 1 & names(result[[1]]) == "No matching results.") {
      result <- try_tibble(data.frame())
    } else {
      result <- data.frame(id = unlist(lapply(result, names)),
                           Subject = unlist(lapply(result, unlist, use.names = FALSE)),
                           stringsAsFactors = FALSE)
      names(result) <- c("id", "Subject")

      result <- try_tibble(result)
    }
  } else if (format == "i") {
    result <- stringr::str_split(response$body, "\n")[[1]]
    result <- Filter(function(r) { nchar(r) > 0 }, result) # Handle no results
    result <- gsub("ticket/", "", result) # Remove "ticket/"
  } else if (format == "l" ) {
    result <- lapply(
      strsplit(response$body, "\\n\\n--\\n\\n")[[1]],
      parse_rt_properties)

    result <- tidy_long_search_result(result, coerce_tibble)
  }

  result
}



