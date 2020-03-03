context("print.rt_api")

test_that("we can print", {
  ex <- structure(
    list(
      path = "/asdf/asdf",
      status = "999",
      message = "Ok",
      body = "..."
    ),
    class = "rt_api"
  )

  output <- capture.output({
    print(ex)
  })

  expect_equal(
    output,
    c("<RT /asdf/asdf>", "  Status: 999", "  Message: Ok", "...")
  )
})

test_that("we can control the number of lines", {
  ex <- structure(
    list(
      path = "/asdf/asdf",
      status = "999",
      message = "Ok",
      body = "a\nb\nc\nd\ne"
    ),
    class = "rt_api"
  )

  output <- capture.output({
    print(ex, n = 0)
  })

  expect_equal(
    output,
    c("<RT /asdf/asdf>", "  Status: 999", "  Message: Ok")
  )

  output_longer <- capture.output({
    print(ex, n = 2)
  })

  expect_equal(
    output_longer,
    c("<RT /asdf/asdf>", "  Status: 999", "  Message: Ok", "a", "b")
  )
})

