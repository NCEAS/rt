context("ticket/attachments")

test_that("we can get a list of attachments", {
  testthat::skip_on_cran()
  skip_unless_integration();

  ticket_id <- rt_ticket_create("General", "root@localhost", "Attachment test")
  attachments <- rt_ticket_attachments(ticket_id)

  testthat::expect_is(attachments, "data.frame")
  testthat::expect_length(attachments, 4)
})

test_that("we can get an attachment", {
  testthat::skip_on_cran()
  skip_unless_integration();

  ticket_id <- rt_ticket_create("General", "root@localhost", "Attachment test")
  attachments <- rt_ticket_attachments(ticket_id)

  attachment <- rt_ticket_attachment(ticket_id, names(attachments)[3])

  testthat::expect_is(attachment, "rt_api")
  testthat::expect_gt(nchar(attachment$body), 0)
})

test_that("we can get an attachment's content", {
  testthat::skip_on_cran()
  skip_unless_integration();

  ticket_id <- rt_ticket_create("General", "root@localhost", "Attachment test")
  attachments <- rt_ticket_attachments(ticket_id)

  # Test fallback behavior (returns httr response when empty)
  content <- rt_ticket_attachment_content(ticket_id, attachments$id[1])
  testthat::expect_is(content, "response")

  # Test happy path: Returns the attachment as requested
  content <- rt_ticket_attachment_content(ticket_id, attachments$id[3])
  testthat::expect_is(content, "response")
})
