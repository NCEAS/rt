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
        paste(c(...), collapse = "/"),
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

  paste(url, query_params_string, sep = "?")
}

#' Compact list.
#'
#' Remove all NULL entries from a list. From \code{plyr::compact()}.
#'
#' @param l list
compact <- function(l) Filter(Negate(is.null), l)


#' Parse an RT response
#'
#' Parse an RT response
#'
#' @param resp_cont (character) The RT ticket response content
#'

parse_ticket <- function(resp_cont) {
  #clean/split response
  resp_split <- resp_cont %>%
    stringr::str_replace_all("^RT.*Ok\n|\n\n$", "") %>% #remove headers/footers
    stringr::str_split("\\n--\\n") %>%  #split if multiple tickets/etc displayed
    unlist(recursive = FALSE)

  resp_processed <- tryCatch(
    lapply(resp_split,
           function(.x){
             tibble::tibble(fields = stringr::str_extract_all(.x, "\n[^: ]+:")[[1]] %>%
                      str_replace_all("\\n|:", "") %>%
                      trimws(),
                    values = stringr::str_split(.x, "\n[^: ]+:")[[1]][-1] %>%
                      trimws()) %>%
               tidyr::spread(fields, values)
           }),
    error = function(e) {NULL})

  out <- dplyr::bind_rows(resp_processed)

  if(nrow(out) == 0){
    return(resp_split)
    warning("The response could not be parsed into a tabular format")
  } else {
    return(out)
  }
}


rt_handle_response <- function(response) {
  if (httr::http_type(response) != "text/plain") {
    stop("API did not return text/plain", call. = FALSE)
  }

  body <- httr::content(response)

  # Since API does not return failure codes; need to parse content strings to check for errors
  if (!is.na(body) & stringr::str_detect(body, "does not exist|Invalid")) {
    stop(
      sprintf(
        "RT API request failed [%s]\n%s",
        httr::status_code(response),
        body
      ),
      call. = FALSE
    )
  }

  if(class(body) != "raw"){
    body <- parse_ticket(body)
  }

  structure(
    list(
      content = body,
      path = url,
      response = response
    ),
    class = "rt_api"
  )
}


#' Get an RT response
#'
#' Get an RT response and format it into an S3 object
#'
#' @param url (character) The full RT URL
#' @param ... Other arguments passed to \code{\link[httr]{GET}}
#'
#' @return (rt_api) The parsed response from RT
rt_GET <- function(url, ...) {
  parse_rt_response(response)
  response <- httr::GET(url, ...,  httr::user_agent(rt_user_agent()))
}

#' POST an RT request
#'
#' @param url (character) The full RT URL
#' @param ... Other arguments passed to \code{\link[httr]{POST}}
#'
#' @return (rt_api) The parsed response from RT
rt_POST <- function(url, ...) {
  parse_rt_response(response)
  response <- httr::POST(url, ..., httr::user_agent(rt_user_agent()))
}


print.rt_api <- function(x, max.lines = 10, width = getOption("width")) {
  cat("<RT ", x$path, ">\n", sep = "")
  cat("  Status: ", x$status, "\n", sep = "")
  cat("  Message: ", x$message, "\n", sep = "")
  cat(x$body, "\n", sep = "")

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
  parsed <- lapply(strsplit(body, "\\n")[[1]], function(x) {
    strsplit(x, ": ")
  })

  result <- lapply(parsed, function(x) { x[[1]][2]})
  names(result) <- vapply(parsed, function(x){ trimws(x[[1]][1]) }, "")

  result
}

#' Get the version of the currently installed version of this package as a
#' character vector
#'
#' @return (character) The version is a character vector, e.g. "1.2.3"
#' @examples
#' get_package_version_string()
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
#' This is used by \link{\code{rt_GET}} and \link{\code{rt_POST}} to provide
#' HTTP requests with an appropriate user agent.
#'
#' @return (character) The user agent string for the package
#'
#' @examples
#' rt_user_agent()
rt_user_agent <- function() {
  paste0("https://github.com/nceas/rt (v", rt_version_string(), ")")
}