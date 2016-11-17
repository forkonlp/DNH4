#' Get Url List By Category
#'
#' Get daum news titles and links from target url.
#'
#' @param turl is target url daum news.
#' @return Get data.frame(news_title, news_links).
#' @export
#' @import xml2
#' @import rvest
#' @import stringr

getUrlListByCategory <- function(turl = url) {
  
  tem <- read_html(turl)
  news_title <- tem %>% rvest::html_nodes("strong.tit_thumb a") %>% rvest::html_text()
  Encoding(news_title) <- "UTF-8"
  news_links <- tem %>% rvest::html_nodes("strong.tit_thumb a") %>% rvest::html_attr("href")
  
  news_lists <- data.frame(news_title = news_title, news_links = news_links, stringsAsFactors = F)

  return(news_lists)
  
}