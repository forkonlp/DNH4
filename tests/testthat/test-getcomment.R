context("test-getcomment.R")

test_that("get one comment work", {
  tar <- "http://v.media.daum.net/v/20100101092104056"
  tem <- getComment(tar)
  print(tem)
  expect_equal(nrow(tem), 1)
})

test_that("get zero comment work", {
  tar <- "http://v.media.daum.net/v/20180516222212362"
  tem <- getComment(tar)
  print(tem)
  expect(is.null(tem), T)
})

test_that("get many comment work", {
  tar <- "http://v.media.daum.net/v/20180516162315753"
  tem <- getComment(tar)
  print(tem)
  chk <- nrow(tem)>1
  expect(chk, T)
})

test_that("get all comment work", {
  for (i in 1:10) {
    tar <- "http://v.media.daum.net/v/20200522093902880"
    tem <- getAllComment(tar)
    print(tem)
    chk <- nrow(tem)>4000
    expect(chk, T) 
  }
})
