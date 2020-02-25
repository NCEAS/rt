context("ticket/search")

test_that("we can search for a ticket we just created", {
  rt_ticket_create("General", "testuser@example.com", "Test")
  rt_ticket_create("General", "testuser@example.com", "Test")
  rt_ticket_create("General", "testuser@example.com", "Test")

  results <- rt_ticket_search("Requestor='testuser@example.com'")

  testthat::expect_is(results, "data.frame")
  testthat::expect_gte(nrow(results), 3)
})

test_that("we can search in different formats", {
  rt_ticket_create("General", "formattest@example.com", "Test")
  rt_ticket_create("General", "formattest@example.com", "Test")
  rt_ticket_create("General", "formattest@example.com", "Test")

  results_default <- rt_ticket_search("Requestor='formattest@example.com'")
  results_s <- rt_ticket_search(
    "Requestor='formattest@example.com'",
    format = "s")
  results_i <- rt_ticket_search(
    "Requestor='formattest@example.com'",
    format = "i")

  testthat::expect_is(results_default, "data.frame")
  testthat::expect_gte(nrow(results_default), 3)

  testthat::expect_is(results_s, "data.frame")
  testthat::expect_gte(nrow(results_s), 3)

  testthat::expect_is(results_i, "character")
  testthat::expect_gte(length(results_i), 3)
})

test_that("asking for specific fields works", {
  rt_ticket_create("General", "fieldstest@example.com", "Test")

  results <- rt_ticket_search("Requestor='fieldstest@example.com'",
                              fields = "Subject")

  testthat::expect_equal(names(results), c("id", "Subject"))
})

test_that("we handle having no search results well", {
  testthat::expect_is(
    rt_ticket_search("Queue = 'NOTFOUND'", format = "l"),
    "data.frame")

  testthat::expect_is(
    rt_ticket_search("Queue = 'NOTFOUND'", format = "s"),
    "data.frame")

  testthat::expect_is(
    rt_ticket_search("Queue = 'NOTFOUND'", format = "i"),
    "character")
})