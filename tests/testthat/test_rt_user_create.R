context("user/create")

test_that("we can create a new user", {
  testthat::skip_on_cran()
  skip_unless_integration()

  user_name <- tolower(paste(sample(LETTERS, 50, TRUE), collapse = ""))
  user_id <- rt_user_create(user_name, "APassword")

  testthat::expect_is(user_id, "numeric")
})

test_that("we throw an error on a failed create", {
  testthat::skip_on_cran()
  skip_unless_integration()

  user_name <- tolower(paste(sample(LETTERS, 50, TRUE), collapse = ""))
  user_id <- rt_user_create(user_name, "APassword")

  testthat::expect_error(
    rt_user_create(user_name, "APassword"),
    "Could not create user"
  )
})
