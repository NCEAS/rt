context("ticket/links")

test_that("a ticket without links returns successfully", {
  testthat::skip_on_cran()

  ticket_id <- rt_ticket_create("General", "root@localhost", "Ticket to edit")
  links <- rt_ticket_links(ticket_id)

  testthat::expect_is(links, "rt_api")
  testthat::expect_equal(
    paste0("id: ticket/", ticket_id, "/links"),
    links$body)
})

test_that("we can add links to a ticket", {
  testthat::skip_on_cran()

  ticket_a <- rt_ticket_create("General", "root@localhost", "Ticket to edit")
  ticket_b <- rt_ticket_create("General", "root@localhost", "Ticket to edit")
  rt_ticket_links_edit(ticket_a, referred_to_by = ticket_b)
  links <- rt_ticket_links(ticket_a)

  testthat::expect_is(links, "rt_api")
  testthat::expect_true(grepl("ReferredToBy", links$body))
})
