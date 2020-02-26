context("user/edit")

test_that("we can edit the properties of a user", {
  testthat::skip_on_cran()

  user_name <- tolower(paste(sample(LETTERS, 50, TRUE), collapse = ""))
  user_id <- rt_user_create(user_name, "APassword")
  edit_response <- rt_user_edit(user_id,
                                organization = "TestOrganizationnnn")

  testthat::expect_true(edit_response)
})

test_that("we get an error when re-using an email address", {
  testthat::skip_on_cran()

  user_a <- tolower(paste(sample(LETTERS, 50, TRUE), collapse = ""))
  user_b <- tolower(paste(sample(LETTERS, 50, TRUE), collapse = ""))
  shared_email <- paste0(user_a, "@example.com")

  user_id_a <- rt_user_create(user_a, "APassword", email_address = shared_email)
  user_id_b <- rt_user_create(user_b, "APassword")

  testthat::expect_error(rt_user_edit(user_id_b,
                                      email_address = shared_email),
                         "Failed to edit")
})
