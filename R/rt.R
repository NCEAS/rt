#' Generate an RT API URL
#'
#' Create an RT API URL based on the server URL and any arguments provided
#'
#' @param rt_base_url (character) The base URL that hosts RT for your organization
#' @param ... Other parameters
#'

rt_url <- function(rt_base_url, ...) {
  stopifnot(nchar(rt_base_url) > 0)
  paste(gsub("\\/$", "", rt_base_url), # Removes trailing slash from base URL just in case
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

#' Get an RT response
#'
#' Get an RT response and format it into an S3 object
#'
#' @param url (character) The full RT URL
#'

rt_GET <- function(url) {
  resp <- httr::GET(url, httr::user_agent("http://github.com/nceas/rt"))
  if (httr::http_type(resp) != "text/plain") {
    stop("API did not return text/plain", call. = FALSE)
  }

  resp_cont <- httr::content(resp)

  # Since API does not return failure codes; need to parse content strings to check for errors
  if (!is.na(resp_cont) & stringr::str_detect(resp_cont, "does not exist|Invalid")) {
    stop(
      sprintf(
        "RT API request failed [%s]\n%s",
        httr::status_code(resp),
        resp_cont
      ),
      call. = FALSE
    )
  }

  if(class(resp_cont) != "raw"){
    resp_cont <- parse_ticket(resp_cont)
  }

  structure(
    list(
      content = resp_cont,
      path = url,
      response = resp
    ),
    class = "rt_api"
  )
}

print.rt_api <- function(x, ...) {
  cat("<RT ", x$path, ">\n", sep = "")
  utils::str(x$content) #is this better than print(x$content)?
  invisible(x)
}
