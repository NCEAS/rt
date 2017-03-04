rt_search <- function(base, query, orderBy=NULL, format="l") {
  url <- paste0(base, "/REST/1.0/search/ticket?query=", query)

  if (!is.null(orderBy)) {
    url <- paste0(url, "&orderBy=", orderBy)
  }

  if (!is.null(format)) {
    url <- paste0(url, "&format=", format)
  }

  req <- httr::GET(url)

  if (req$status_code != 200) {
    stop(req, call. = FALSE)
  }


  if (format != "l") {
    return(req)
  }

  result_split <- lapply(stringr::str_split(httr::content(req), "\\n--\\n"), stringr::str_split, "\\n")[[1]]

  parse_rt_result <- function(x) {
    lines_f <- Filter(function(x) { stringr::str_detect(x, ": ")}, x)
    parts <- stringr::str_split(lines_f, ": ")
    x <- do.call(list, lapply(parts, function(p) paste0(p[-1], collapse = ": ")))
    names(x) <- lapply(parts, function(p) p[[1]])

    x
  }

  y <- lapply(result_split, parse_rt_result)

  result <- data.frame()

  for (z in y) {
    zdf <- as.data.frame(z, stringsAsFactors = FALSE)

    if (nrow(result) > 0 ) {
      for (name in setdiff(names(result), names(zdf))) {
        zdf[,name] <- NA
      }

      for (name in setdiff(names(zdf), names(result))) {
        result[,name] <- NA
      }
    }

    result <- rbind(result, zdf)
  }

  result
}

