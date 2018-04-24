context("Test login")

test_that("A bad username/password returns an error", {
  expect_error(rt_login("user", "pass", "https://support.nceas.ucsb.edu/rt/REST/1.0"))
})