# Log us in if we're not on CRAN
if (!testthat:::on_cran()) {
  Sys.setenv(RT_BASE_URL = "http://localhost")
  rt_login("root", "password")
}
