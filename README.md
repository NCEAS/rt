[![Build Status](https://travis-ci.org/NCEAS/rt.svg?branch=master)](https://travis-ci.org/NCEAS/rt)

# rt
### *An R package for the [RequestTracker REST API](https://rt-wiki.bestpractical.com/wiki/REST)*

## Installation

You can install the development version from GitHub with:

```{r}
devtools::install_github("NCEAS/rt")
```

## Set-up

To start using the `rt` R package, log in to your RT instance by setting the server URL in your `options` and using either the `rt_login()` or `rt_login_interactive()` functions. We recommend using `rt_login_interactive()` to avoid storing your username and password in your R script.

```{r message = FALSE}
library(rt)

options(rt_base = "https://demo.bestpractical.com/") #set your server name
rt_login(user = "guest", pass = "guest") #generally, you'd use rt_login_interactive()
```
Once you are successfully logged in, you can use R to read and write to RT.

## `rt_api` class objects

GET calls to the [RequestTracker REST API](https://rt-wiki.bestpractical.com/wiki/REST) are returned as `rt_api` objects, a list of 3 elements: 

1. the `content`, generally returned as a tibble/data frame
2. the `path` or URL that was accessed
3. the HTTP `response` from the API.

## Logging out

To log out, use the `rt_logout` function or restart your R session.

```{r eval = FALSE}
rt_logout()
```

## Support / Issues / Feedback

[Let us know](https://github.com/NCEAS/rt/issues) about any issues or bugs.

## Acknowledgements

Support was provided by the National Center for Ecological Analysis and Synthesis, a Center funded by the University of California, Santa Barbara, and the State of California.

[![nceas_footer](https://www.nceas.ucsb.edu/files/newLogo_0.png)](http://www.nceas.ucsb.edu)
