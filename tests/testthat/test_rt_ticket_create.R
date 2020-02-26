context("ticket/create")

test_that("a ticket can be created", {
  testthat::skip_on_cran()
  skip_unless_integration();

  ticket <- rt_ticket_create("General")

  ticket <- rt_ticket_create("General",
                             "root@localhost",
                             "Test")

  testthat::expect_is(ticket, "numeric")
})
