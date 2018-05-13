context("test-getcomment.R")

tar <- "http://v.media.daum.net/v/20100101092104056"

test_that("get comment work", {
  tem <- getComment(tar)
  expect_equal(nrow(tem), 1)
})
