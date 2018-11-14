context("ticket/search")

test_that("we can search for a ticket we just created", {
  rt_ticket_create("General", "testuser@example.com", "Test")
  rt_ticket_create("General", "testuser@example.com", "Test")
  rt_ticket_create("General", "testuser@example.com", "Test")

  results <- rt_ticket_search("Requestor='testuser@example.com'")

  testthat::expect_is(results, "list")
  testthat::expect_gte(length(results), 3)
})

test_that("we can search in different formats", {
  rt_ticket_create("General", "formattest@example.com", "Test")
  rt_ticket_create("General", "formattest@example.com", "Test")
  rt_ticket_create("General", "formattest@example.com", "Test")

  results_default <- rt_ticket_search("Requestor='formattest@example.com'")
  results_s <- rt_ticket_search("Requestor='formattest@example.com'", format = "s")
  results_i <- rt_ticket_search("Requestor='formattest@example.com'", format = "i")

  testthat::expect_is(results_default, "list")
  testthat::expect_gte(length(results_default), 3)

  testthat::expect_is(results_s, "list")
  testthat::expect_gte(length(results_s), 3)

  testthat::expect_is(results_i, "character")
  testthat::expect_gte(length(results_i), 3)
})

test_that("ordering works", {
  rt_ticket_create("General", "ordertest@example.com", "Test")
  rt_ticket_create("General", "ordertest@example.com", "Test")

  results <- rt_ticket_search("Requestor='ordertest@example.com'", orderby = "+Created")
  results_flipped <- rt_ticket_search("Requestor='ordertest@example.com'", orderby = "-Created")

  testthat::expect_true(results[[1]]$id != results_flipped[[1]]$id)
})

test_that("asking for specific fields works", {
  rt_ticket_create("General", "fieldstest@example.com", "Test")

  results <- rt_ticket_search("Requestor='ordertest@example.com'",
                              fields = "Subject")

  testthat::expect_equal(names(results[[1]]), c("id", "Subject"))
})