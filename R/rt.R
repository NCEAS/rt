#' Generate an RT API URL
#'
#' Create an RT API URL based on the server URL and any arguments provided
#'
#' @param rt_base_url (character) The base URL that hosts RT for your organization
#' @param ... Other parameters
#'

rt_url <- function(..., base_url = Sys.getenv("RT_BASE_URL")) {
  if (!is.character(base_url) || nchar(base_url) <= 0) {
    stop("Invalid RT base URL: ",
         "See ?rt for information on how to get started. ",
         call. = FALSE)
  }
  paste(gsub("\\/$", "", base_url), # Removes trailing slash from base URL just in case
        "REST",
        "1.0",
        paste(c(...), collapse = "/"),
        sep = "/")
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
#'
rt_GET <- function(url, ...) {
  response <- httr::GET(url, ..., httr::user_agent("http://github.com/nceas/rt"))
  parse_rt_response(response)
}

rt_POST <- function(url, ...) {
  response <- httr::POST(url, ..., httr::user_agent("http://github.com/nceas/rt"))
  parse_rt_response(response)
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
#' @param response (rt_response)
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