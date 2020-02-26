context("ticket/create")

test_that("a ticket can be created", {
  testthat::skip_on_cran()

  ticket <- rt_ticket_create("General")

  ticket <- rt_ticket_create("General",
                             "root@localhost",
                             "Test")

  testthat::expect_is(ticket, "numeric")
})
