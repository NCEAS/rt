context("ticket/history")

test_that("we can get the history of a ticket in long format", {
  testthat::skip_on_cran()
  skip_unless_integration();

  ticket_id <- rt_ticket_create("General", "root@localhost", "Ticket to edit")
  history_long <- rt_ticket_history(ticket_id)

  testthat::expect_is(history_long, "rt_api")
  testthat::expect_true(nchar(history_long$body) > 0)
})

test_that("we can get the history of a ticket in short format", {
  testthat::skip_on_cran()
  skip_unless_integration();

  ticket_id <- rt_ticket_create("General", "root@localhost", "Ticket to edit")
  history_short <- rt_ticket_history(ticket_id, format = "s")

  testthat::expect_is(history_short, "rt_api")
  testthat::expect_true(nchar(history_short$body) > 0)
})

test_that("we can comment on a ticket", {
  testthat::skip_on_cran()
  skip_unless_integration();

  ticket_id <- rt_ticket_create("General", "root@localhost", "Ticket to edit")
  rt_ticket_history_comment(ticket_id, "Testing commenting")
  history <- rt_ticket_history(ticket_id)

  testthat::expect_is(history, "rt_api")
  testthat::expect_true(grepl("Content: Testing commenting", history$body))
})

test_that("we can reply to a ticket", {
  testthat::skip_on_cran()
  skip_unless_integration();

  ticket_id <- rt_ticket_create("General", "root@localhost", "Ticket to edit")
  rt_ticket_history_reply(ticket_id, "Testing replying",)
  history <- rt_ticket_history(ticket_id)

  testthat::expect_is(history, "rt_api")
  testthat::expect_true(grepl("Content: Testing replying", history$body))
})
