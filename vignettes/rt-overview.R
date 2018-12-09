## ----setup, include = FALSE----------------------------------------------
# knitr::opts_chunk$set(eval = FALSE)
library(knitr)
library(kableExtra)

format_result <- function(query_result) {
  query_result %>% 
    knitr::kable(format = "html") %>% 
    kableExtra::kable_styling(bootstrap_options = c("striped", "hover", "condensed")) %>% 
    kableExtra::scroll_box(width = "100%",
                           height = "400px") #display concisely
}

## ----default-fields, echo = FALSE----------------------------------------
c("AdminCc", "Created", "Creator", "Due", "FinalPriority", "id", "InitialPriority", "LastUpdated", "Owner", "Priority", "Queue", "Requestors", "Resolved", "Started", "Starts", "Status", "Subject", "TimeEstimated", "TimeLeft", "TimeWorked", "Told", "CF.{NAME_OF_CUSTOM_FIELD}")

## ----load-and-connect, message = FALSE-----------------------------------
library(rt)

Sys.setenv(RT_BASE_URL = "http://localhost:8080") # Your RT installation's URL (where you log in)
rt_login(user = "root", pass = "password") # Or use rt_login_interactive()

## ----first-query---------------------------------------------------------
result <- rt_ticket_search("Queue = 'General'")

## ----formatted-first-query, echo = FALSE---------------------------------
format_result(result$content)

## ----query-and, eval = FALSE---------------------------------------------
#  result <- rt_ticket_search("Queue = 'General' AND Subject LIKE 'test'")

## ----query-parens, eval = FALSE------------------------------------------
#  result <- rt_ticket_search("(Status = 'new' OR Status = 'open') AND Queue = 'General'")

## ----query-dates, eval = FALSE-------------------------------------------
#  result <- rt_ticket_search("Created > '2018-04-04'")

## ----query-dates-special, eval = FALSE-----------------------------------
#  result <- rt_ticket_search("Created >= '2 days ago'")

## ----query-like, eval = FALSE--------------------------------------------
#  result <- rt_ticket_search("Content LIKE 'Can you please advise'")

