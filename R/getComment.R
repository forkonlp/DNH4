#' Get Comment
#'
#' Get daum news comments
#' if you want to get data only comment, enter commend like below.
#' getComment(url)$result$commentList[[1]]
#'
#' @param turl like 'http://v.media.daum.net/v/20161117210603961'.
#' @param limit is number of comment. defult is 10.
#' @param parentId defult is 0.
#' @param sort you can select RECOMMEND, LATEST. RECOMMEND is defult.
#' @return Get data.frame.
#' @export
#' @import httr
#' @import rvest
#' @import jsonlite
#' @import stringr

getComment <- function(turl = url, limit = 10, parentId=0, sort = c("RECOMMEND", "LATEST")) {
  
  client_id <- GET(turl) %>% content %>% html_nodes(".alex-area") %>% html_attr("data-client-id")
  
  tar <- paste0("https://comment.daum.net/auth/credential?client_id=",client_id)
  ad <- add_headers("Referer"=turl)
  auth <- GET(tar,ad) %>% content
  
  post_id <- strsplit(turl, "/")[[1]]
  post_id <- post_id[length(post_id)]
  
  tar <- paste0("http://comment.daum.net/apis/v1/posts/@", post_id)
  ad <- add_headers("Authorization"= paste0("Bearer ",auth$access_token))
  comment_info <- GET(tar,ad) %>% content
  
  tar <- paste0("http://comment.daum.net/apis/v1/posts/", comment_info$id, "/comments?parentId=",parentId,"&offset=0&limit=",limit,"&sort=",sort[1])
  
  
  dat <- GET(tar) %>% content
  
  return(dat)
  
}