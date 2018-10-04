context("ticket")

Sys.setenv(RT_BASE_URL = "http://localhost:8080")
rt_login("root", "password")

test_that("a ticket can be created", {
  ticket <- rt_ticket_create(queue = "General",
                             requestor = "root@localhost",
                             subject = " Test")

  testthat::expect_true(is.numeric(ticket))
})