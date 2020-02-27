context("parse_properties")

test_that("can parse a simple properties response", {
  expect_equal(
    parse_rt_properties("id: 1"),
    list(id = "1")
  )

  ex2 <- paste0("id: ticket/1\nQueue: General\nOwner: Nobody\n",
                "Creator: me@example.com\nSubject: somesubject\n")
  expect_equivalent(
    parse_rt_properties(ex2),
    list(id = "ticket/1",
         Queue = "General",
         Owner = "Nobody",
         Creator = "me@example.com",
         Subject = "somesubject")
  )
})

test_that("can parse a tricky multiline properties response", {
  tricky <- paste0("id: ticket/57\nQueue: General\nOwner: Nobody\nCreator: ",
  "travis@example.com\nSubject: consequatur maxime omnis molestiae esse ipsum ",
  "voluptatem commodi excepturi blanditiis\nStatus: new\nPriority: 0\n",
  "InitialPriority: 0\nFinalPriority: 0\n\nRequestors: barlow@example.com, ",
  "bryant@example.com, frye@example.com,\n            travis@example.com, ",
  "woodard@example.com\n\nCc: raymond@example.com\nAdminCc:\nCreated: Wed ",
  "Apr 24 12:03:22 2019\nStarts: Not set\nStarted: Not set\nDue: Not set\n",
  "Resolved: Not set\nTold: Not set\nLastUpdated: Sun Feb 23 00:03:31 2020\n",
  "TimeEstimated: 0\nTimeWorked: 0\nTimeLeft: 0")

  expect_equivalent(
    parse_rt_properties(tricky),
    list(id = "ticket/57",
         Queue = "General",
         Owner = "Nobody",
         Creator = "travis@example.com",
         Subject = paste0("consequatur maxime omnis molestiae esse ipsum ",
                          "voluptatem commodi excepturi blanditiis"),
         Status = "new",
         Priority = "0",
         InitialPriority = "0",
         FinalPriority = "0",
         Requestors = paste0(
          "barlow@example.com, bryant@example.com, frye@example.com, ",
          "travis@example.com, woodard@example.com"),
         Cc = "raymond@example.com",
         `AdminCc:` = NA_character_,
         Created = "Wed Apr 24 12:03:22 2019",
         Starts = "Not set",
         Started = "Not set",
         Due = "Not set",
         Resolved = "Not set",
         Told = "Not set",
         LastUpdated = "Sun Feb 23 00:03:31 2020",
         TimeEstimated = "0",
         TimeWorked = "0",
         TimeLeft = "0")
  )
})