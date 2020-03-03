#' Generate an RT API URL
#'
#' Create an RT API URL based on the server URL and any arguments provided
#'
#' @param ... Parts of the URL to be joined by "/"
#' @param query_params (list) A named list of query parameters where the names
#' of the list map to the query parameter names and the values of the list map
#' to the query parameter values. e.g., \code{list(a=1)} maps to \code{"?a=1"}.
#' @param base_url (character) The base URL that hosts RT for your organization
rt_url <- function(...,
                   query_params=NULL,
                   base_url = Sys.getenv("RT_BASE_URL")) {
  if (!is.character(base_url) || nchar(base_url) <= 0) {
    stop("Invalid RT base URL: ",
         "See ?rt for information on how to get started. ",
         call. = FALSE)
  }

  # Form the first part of the URL
  url <- paste(gsub("\\/$", "", base_url), # Removes trailing slash from base
                                           # URL just in case
        "REST",
        "1.0",
        paste(
          vapply(c(...),
                 function(x) { trimws(format(x, scientific = FALSE)) },
                 ""),
          collapse = "/"),
        sep = "/")

  # Add in query parameters
  query_params_clean <- compact(query_params)

  # Create a string of query params
  # Converts to char and URL encode values along the way
  query_params_string <- paste(
    paste(
      names(query_params_clean),
      vapply(
        vapply(query_params_clean,
               as.character,
               ""),
        utils::URLencode,
        "",
        reserved = TRUE),
      sep = "="),
    collapse = "&")

  if (nchar(query_params_string) > 0) {
    url <- paste(url, query_params_string, sep = "?")
  }

  url
}

#' Compact list.
#'
#' Remove all NULL entries from a list. From \code{plyr::compact()}.
#'
#' @param l list
compact <- function(l) Filter(Negate(is.null), l)

#' Construct a string for params suitable for passing into an RT request
#'
#' RT's API, in a few cases, takes a body of key value pairs that are colon
#' separated and each key value pair is newline separated. Each pair is also
#' run through \code{\link{compact}} to remove \code{NULL} elements.
#'
#' @param params (list) One or more key value pairs
#'
#' @return (character)
construct_newline_pairs <- function(params) {
  params_clean <- compact(params)
  paste(names(params_clean), params_clean, sep = ": ", collapse = "\n")
}


#' Get an RT response
#'
#' Get an RT response and format it into an S3 object
#'
#' @param url (character) The full RT URL
#' @param raw (logical) Whether or not to return the raw response from \
#' code{\link[httr]{GET}} (\code{TRUE}) or not (\code{FALSE})
#' @param ... Other arguments passed to \code{\link[httr]{GET}}
#'
#' @return (rt_api) The parsed response from RT
rt_GET <- function(url, raw = FALSE, ...) {
  response <- httr::GET(url, ...,  httr::user_agent(rt_user_agent()))
  stopforstatus(response)

  if (raw) {
    return(response)
  }

  rt_parse_response(response)
}

#' POST an RT request
#'
#' @param url (character) The full RT URL
#' @param raw (logical) Whether or not to return the raw response from \
#' code{\link[httr]{POST}} (\code{TRUE}) or not (\code{FALSE})
#' @param ... Other arguments passed to \code{\link[httr]{POST}}
#'
#' @return (rt_api) The parsed response from RT
rt_POST <- function(url, raw = FALSE, ...) {
  response <- httr::POST(url, ..., httr::user_agent(rt_user_agent()))
  stopforstatus(response)

  if (raw) {
    return(response)
  }

  rt_parse_response(response)
}


#' Print an `rt_api` object
#'
#' @param x object of class `rt_api`
#' @param ... Other arguments passed to \code{\link[utils]{head}}
#'
#' @export
print.rt_api <- function(x, ...) {
  cat("<RT ", x$path, ">\n", sep = "")
  cat("  Status: ", x$status, "\n", sep = "")
  cat("  Message: ", x$message, "\n", sep = "")
  cat(paste(
    utils::head(strsplit(x$body, "\n")[[1]], ...),
    collapse = "\n"))

  invisible(x)
}

#' Parse typical RT properties as contained in an RT response body
#'
#' The code gives a basic idea of the format but it's basically
#' newline-separated key-value pairs with a ': ' between them. e.g.,
#'
#'   id: queue/1
#'   Name: General
#'
#' @param body (character) Response body from an \code{rt_response}
#'
#' @return List of properties
parse_rt_properties <- function(body) {
  # Split into fields
  fields <- strsplit(body, "[\n]+")[[1]]

  # Merge multi-line fields into the previous
  for (i in which(grepl("^[ ]+", fields))) {
    # Merge with previous, triming repeat leading whitespace because the
    # second line is tabtop aligned for some odd reason
    fields[i - 1] <- paste0(fields[i - 1], gsub("[ ]{2,}", " ", fields[i]))
    fields <- fields[-i]
  }

  parsed <- lapply(fields, function(x) {
    strsplit(x, ": ")
  })

  result <- lapply(parsed, function(x) { x[[1]][2]})
  names(result) <- vapply(parsed, function(x) { trimws(x[[1]][1]) }, "")

  result
}

#' Get the version of the currently installed version of this package as a
#' character vector
#'
#' @return (character) The version is a character vector, e.g. "1.2.3"
rt_version_string <- function() {
  path <- system.file("DESCRIPTION", package = "rt")

  if (!file.exists(path)) {
    return("")
  }

  description <- readLines(path)
  index <- grep("Version", description)

  if (length(index) != 1) {
    return("")
  }

  version_string <- gsub("Version: ", "", description[index])

  if (nchar(version_string) <= 0) {
    return("")
  }

  version_string
}

#' Get the user agent for the package.
#'
#' This is used by \code{\link{rt_GET}} and \code{\link{rt_POST}} to provide
#' HTTP requests with an appropriate user agent.
#'
#' @return (character) The user agent string for the package
rt_user_agent <- function() {
  paste0("https://github.com/nceas/rt (v", rt_version_string(), ")")
}
