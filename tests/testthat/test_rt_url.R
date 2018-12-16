context("rt")

test_that("can construct URLs", {
  expect_equal(rt_url("a"),
               "http://localhost:8080/REST/1.0/a")
  expect_equal(rt_url("a", "b"),
               "http://localhost:8080/REST/1.0/a/b")
  expect_equal(rt_url("a", "b", 3),
               "http://localhost:8080/REST/1.0/a/b/3")
})

test_that("can construct URLs with query parameters", {
  expect_equal(rt_url("asdf", query_params = list(param = "foo")),
               "http://localhost:8080/REST/1.0/asdf?param=foo")
  expect_equal(rt_url("asdf", query_params = list(param = "foo",
                                                    other_param = "bar")),
               "http://localhost:8080/REST/1.0/asdf?param=foo&other_param=bar")
})

test_that("removes NULL items from query params", {
  expect_equal(rt_url("asdf", query_params = list(param = NULL)),
               "http://localhost:8080/REST/1.0/asdf")
  expect_equal(rt_url("asdf", query_params = list(param = 1, other = NULL)),
               "http://localhost:8080/REST/1.0/asdf?param=1")
})
