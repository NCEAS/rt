[![Build Status](https://travis-ci.org/NCEAS/rt.svg?branch=master)](https://travis-ci.org/NCEAS/rt)

# rt

An R package for the [RequestTracker REST API](https://rt-wiki.bestpractical.com/wiki/REST).

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
rt_login()
```

Once you are successfully logged in, you're all set to use the package.
The `rt` package supports all of the [RequestTracker REST API](https://rt-wiki.bestpractical.com/wiki/REST):

- General
  - Login: `rt_login()`
  - Logout: `rt_logout()`
- Tickets
  - Ticket Properties: `rt_ticket()`
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
  - User Properties: `rt_user()`
  - User Create: `rt_user_create()`
  - User Edit: `rt_user_edit()`
- Queues
  - Queue Properties: `rt_queue()`

### `rt_api` objects

GET calls to the [RequestTracker REST API](https://rt-wiki.bestpractical.com/wiki/REST) are returned as `rt_api` objects, a list of 3 elements: 

1. the `content`, generally returned as a tibble/data frame
2. the `path` or URL that was accessed
3. the HTTP `response` from the API.

### Logging out

To log out, use the `rt_logout` function (or restart your R session):

```r
rt_logout()
```

Note: Credentials for your `rt` session are stored using `httr`'s automatic re-use of cookies.

## Support / Issues / Feedback

[Let us know](https://github.com/NCEAS/rt/issues) about any issues or bugs.

## Acknowledgements

Support was provided by the National Center for Ecological Analysis and Synthesis, a Center funded by the University of California, Santa Barbara, and the State of California.

[![nceas_footer](https://www.nceas.ucsb.edu/files/newLogo_0.png)](http://www.nceas.ucsb.edu)
