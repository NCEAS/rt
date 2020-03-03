context("rt")

test_that("can construct URLs", {
  testthat::skip_on_cran()
  skip_unless_integration()

  expect_equal(rt_url("a"),
               "http://localhost/REST/1.0/a")
  expect_equal(rt_url("a", "b"),
               "http://localhost/REST/1.0/a/b")
  expect_equal(rt_url("a", "b", 3),
               "http://localhost/REST/1.0/a/b/3")
})

test_that("can construct URLs with query parameters", {
  testthat::skip_on_cran()
  skip_unless_integration()

  expect_equal(rt_url("asdf", query_params = list(param = "foo")),
               "http://localhost/REST/1.0/asdf?param=foo")
  expect_equal(rt_url("asdf", query_params = list(param = "foo",
                                                    other_param = "bar")),
               "http://localhost/REST/1.0/asdf?param=foo&other_param=bar")
})

test_that("removes NULL items from query params", {
  testthat::skip_on_cran()
  skip_unless_integration()

  expect_equal(rt_url("asdf", query_params = list(param = NULL)),
               "http://localhost/REST/1.0/asdf")
  expect_equal(rt_url("asdf", query_params = list(param = 1, other = NULL)),
               "http://localhost/REST/1.0/asdf?param=1")
})


test_that("rt_url doesn't convert numeric params to scientific", {
  testthat::skip_on_cran()
  skip_unless_integration()

  expect_equal(rt_url("foo", 111111111, 999999999),
               "http://localhost/REST/1.0/foo/111111111/999999999")
})
