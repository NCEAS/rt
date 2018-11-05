context("ticket/search")

test_that("we can search for a ticket we just created", {
  rt_ticket_create("General", "testuser@example.com", "Test")
  rt_ticket_create("General", "testuser@example.com", "Test")
  rt_ticket_create("General", "testuser@example.com", "Test")

  results <- rt_ticket_search("Requestor='testuser@example.com'")

  testthat::expect_is(results, "list")
  testthat::expect_gte(length(results), 3)
})