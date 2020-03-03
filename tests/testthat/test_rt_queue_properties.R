context("queue/properties")

test_that("we can get the properties of a queue", {
  testthat::skip_on_cran()
  skip_unless_integration()

  props <- rt_queue_properties("General")

  testthat::expect_is(props, "list")
  testthat::expect_length(props, 7)
  testthat::expect_true(props$Name == "General")
})

test_that("we throw an error on queue not found", {
  testthat::skip_on_cran()
  skip_unless_integration()

  testthat::expect_error(
    rt_queue_properties("AQueueThatDoesntExist"), "No queue")
})
