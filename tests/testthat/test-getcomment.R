context("test-getcomment.R")

test_that("get one comment work", {
  tar <- "http://v.media.daum.net/v/20100101092104056"
  tem <- getComment(tar)
  expect_equal(nrow(tem), 1)
})

test_that("get zero comment work", {
  tar <- "http://v.media.daum.net/v/20180516222212362"
  tem <- getComment(tar)
  expect(is.null(tem), T)
})

test_that("get many comment work", {
  tar <- "http://v.media.daum.net/v/20180516162315753"
  tem <- getComment(tar)
  chk <- nrow(tem)>1
  expect(chk, T)
})

test_that("get all comment work", {
  tar <- "http://v.media.daum.net/v/20180516162315753"
  tem <- getComment(tar,limit="all")
  chk <- nrow(tem)>1
  expect(chk, T)
})
