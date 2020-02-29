context("user/properties")

test_that("we can get the properties of a user", {
  testthat::skip_on_cran()
  skip_unless_integration()

  props <- rt_user_properties(1)

  testthat::expect_is(props, "list")
  testthat::expect_length(props, 6)
  testthat::expect_true(props$Name == "RT_System")
})

test_that("we throw an error on user not found", {
  testthat::skip_on_cran()
  skip_unless_integration()

  testthat::expect_error(
    rt_user_properties(2), "does not exist")
})
