context("ticket/properties")

test_that("we can get properties of a ticket", {
  ticket <- rt_ticket_create("General")
  props <- rt_ticket_properties(ticket)

  testthat::expect_is(props, "list")
  testthat::expect_equal(props$id, paste0("ticket/", ticket))
})

test_that("trying to get properties of a non-existent ticket errors", {
  testthat::expect_error(rt_ticket_properties(9999), "does not exist")
})