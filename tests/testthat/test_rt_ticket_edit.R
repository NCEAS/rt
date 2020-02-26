context("ticket/edit")

test_that("we can edit a ticket", {
  testthat::skip_on_cran()
  skip_unless_integration();

  ticket_id <- rt_ticket_create("General", "root@localhost", "Ticket to edit")
  rt_ticket_edit(ticket_id, subject = "Edited subject")
  props <- rt_ticket_properties(ticket_id)

  testthat::expect_is(props, "list")
  testthat::expect_true(props$Subject == "Edited subject")
})
