#' Get News Main Categories
#'
#' Get daum news main category names and ids recently.
#'
#' @return Get data.frame(chr:cate_name, chr:url).
#' @export
#' @import xml2
#' @import rvest
#' @import stringr

getMainCategory <- function() {
  
  print("This function use internet. If get error, please check the internet.")
  home <- "http://media.daum.net/breakingnews"
  titles <- read_html(home) %>% html_nodes("div#mArticle ul.tab_nav li a") %>% html_text()
  titles <- str_trim(titles)
  links <- read_html(home) %>% html_nodes("div#mArticle ul.tab_nav li a") %>% html_attr("href")
  links <- gsub("/breakingnews","",links)
  urls <- data.frame(cate_name=titles,url=links,stringsAsFactors = F)
  urls <- urls[-1,]
  return(urls)
  
}
