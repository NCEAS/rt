context("ticket/search")

test_that("we can search for a ticket we just created", {
  testthat::skip_on_cran()
  skip_unless_integration()

  rt_ticket_create("General", "testuser@example.com", "Test")
  rt_ticket_create("General", "testuser@example.com", "Test")
  rt_ticket_create("General", "testuser@example.com", "Test")

  results <- rt_ticket_search("Requestor='testuser@example.com'")

  testthat::expect_is(results, "data.frame")
  testthat::expect_gte(nrow(results), 3)
})

test_that("we can search in different formats", {
  testthat::skip_on_cran()
  skip_unless_integration()

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
  testthat::skip_on_cran()
  skip_unless_integration()

  rt_ticket_create("General", "fieldstest@example.com", "Test")

  results <- rt_ticket_search("Queue='General'", fields = "Subject")

  testthat::expect_equal(names(results), c("id", "Subject"))
})

test_that("we handle having no search results well", {
  testthat::skip_on_cran()
  skip_unless_integration()

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

test_that("try_tibble works as expected", {
  testthat::expect_is(try_tibble(data.frame(), FALSE), "data.frame")

  if (requireNamespace("tibble")) {
    testthat::expect_is(try_tibble(data.frame()), "tbl_df")
  } else {
    testthat::expect_is(try_tibble(data.frame()), "data.frame")
  }
})

test_that("tidy_long_search_result works as expected", {
  testthat::expect_is(tidy_long_search_result(
    list(list("id" = 1))),
    "data.frame")

  testthat::expect_is(tidy_long_search_result(
    list(
      list("id" = 1, "Subject" = "Foo"),
      list("id" = 2, "Subject" = "Foo")
      )),
    "data.frame")

  # Test sanitization of ticket ids
  result <- tidy_long_search_result(list(list("id" = "ticket/1")))
  testthat::expect_is(result, "data.frame")
  testthat::expect_true(result$id[1] == "1")
})
