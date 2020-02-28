[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
![CI](https://github.com/NCEAS/rt/workflows/CI/badge.svg)
![Tests](https://github.com/NCEAS/rt/workflows/Integration/badge.svg)
[![cran version](https://www.r-pkg.org/badges/version/rt)](https://cran.r-project.org/package=rt)
[![cran checks](https://cranchecks.info/badges/worst/rt)](https://cranchecks.info/pkgs/rt)

# rt

An R package for the [RequestTracker API](https://rt-wiki.bestpractical.com/wiki/REST).

## Installation

You can install the development version from GitHub with:

```r
remotes::install_github("NCEAS/rt")
```

## Usage

### Setup

To start using the `rt` R package, log in to your RT instance by setting the server URL in using `Sys.setenv` and use `rt_login()` to log in and store your session locally:

```r
library(rt)

Sys.setenv("RT_BASE_URL"="https://demo.bestpractical.com")
rt_login() # Enter demo/demo
```

Once you are successfully logged in, you're all set to use the package.
The `rt` package supports all of the [RequestTracker REST API](https://rt-wiki.bestpractical.com/wiki/REST):

- General
  - Login: `rt_login()`
  - Logout: `rt_logout()`
- Tickets
  - Ticket Properties: `rt_ticket_properties()`
  - Ticket Links: `rt_ticket_links()`
  - Ticket Attachments: `rt_ticket_attachments()`
  - Ticket Attachment: `rt_ticket_attachment()`
  - Ticket Attachment Content: `rt_ticket_attachment_content()`
  - Ticket History: `rt_ticket_history()`
  - Ticket History Entry: `rt_ticket_history_entry()`
  - Ticket Search: `rt_ticket_search()`
  - Ticket Create: `rt_ticket_create()`
  - Ticket Edit: `rt_ticket_edit()`
  - Tickets History Reply: `rt_ticket_history_reply()`
  - Ticket History Comment: `rt_ticket_history_comment()`
  - Ticket Links Edit: `rt_ticket_links_edit()`
- Users
  - User Properties: `rt_user_properties()`
  - User Create: `rt_user_create()`
  - User Edit: `rt_user_edit()`
- Queues
  - Queue Properties: `rt_queue_properties()`

Note: Most of these functions support being chained together (for example, with the `%>%`).

### Logging out

To log out, use the `rt_logout` function (or restart your R session):

```r
rt_logout()
```

Note: Credentials for your `rt` session are stored using `httr`'s automatic re-use of cookies.

## Development & Testing

A Dockerfile is available at the root of the repository so it's easy to get a test installation of RT up and running.
The tests need this to run so make sure to run the following before running the tests:

```sh
docker run -d --name rt -p 80:80 netsandbox/request-tracker
```

You can then navigate to http://localhost:8080 and log in as user `root` with password `password`.
Be aware the tests are hard-coded against http://localhost:8080.

By default, only unit tests are run.
To run all tests, including integration tests, make sure you've started the above Docker container and then set:

```r
Sys.setenv("RT_INTEGRATION" = TRUE)
```

### `rt_api` objects

All API calls go through an intermediate state as an `rt_api` obejct, which is made up of three parts:

1. the `content`, generally returned as a tibble/data frame
2. the `path` or URL that was accessed
3. the HTTP `response` from the API.

This is mainly to help normalie out some of the inconsistencies in the RT API itself and make implementing the API call wrappers easier.

## Support / Issues / Feedback

[Let us know](https://github.com/NCEAS/rt/issues) about any issues or bugs.

## Acknowledgements

Support was provided by the National Center for Ecological Analysis and Synthesis, a Center funded by the University of California, Santa Barbara, and the State of California.

[![nceas_footer](https://www.nceas.ucsb.edu/files/newLogo_0.png)](https://www.nceas.ucsb.edu)
