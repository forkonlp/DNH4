#' Get Comment
#'
#' Get daum news comments
#' if you want to get data only comment, enter commend like below.
#' getComment(url)$result$commentList[[1]]
#'
#' @param turl like 'http://v.media.daum.net/v/20161117210603961'.
#' @param pageSize is number of comment. defult is 10.
#' @param page is defult is 1.
#' @param sort you can select favorite, reply, old, new. favorite is defult.
#' @return Get data.frame.
#' @export
#' @import httr
#' @import jsonlite
#' @import stringr

getComment <- function(turl = url, limit = 1, parentId=0, sort = c("RECOMMEND", "LATEST")) {
  
  sort <- sort[1]
  tem <- stringr::str_split(turl, "/")[[1]]
  aid <- tem[length(tem)]
  
  tem <- paste0("http://comment.daum.net/apis/v1/posts/@",aid)
  con <- httr::GET(url)
  con <- httr::GET(url, httr::add_headers(authorization = turl))
  con <- httr::GET(tem)
  con
  url <- paste0("http://comment.daum.net/apis/v1/posts/",aid,"/comments?parentId=",parentId,"&offset=0&limit=",limit,"&sort=",sort)
  con <- httr::GET(url)
  tt <- httr::content(con, "text")
  
  tt <- gsub("_callback", "", tt)
  tt <- gsub("\\(", "[", tt)
  tt <- gsub("\\)", "]", tt)
  tt <- gsub(";", "", tt)
  tt <- gsub("\n", "", tt)
  
  data <- jsonlite::fromJSON(tt)
  print(paste0("success : ", data$success))
  return(data)
  
}