context("login/logout")

test_that("we can log in", {
  expect_true(rt_login("root", "password", "http://localhost:8080"))
})