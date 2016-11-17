#' Get News Sub Categories
#'
#' Get daum news sub category names and urls recently.
#'
#' @param categoryUrl Main category url in daum news. Only 1 value is passible. Default is society.
#' @return Get data.frame(chr:sub_cate_name, chr:url).
#' @export
#' @import xml2
#' @import rvest
#' @import stringr

getSubCategory <- function(categoryUrl="/society") {
  
  print("This function use internet. If get error, please check the internet.")
  home <- paste0("http://media.daum.net/breakingnews",categoryUrl)
  tem <- read_html(home)
  titles <- tem %>% html_nodes("div.box_subtab ul li a") %>% html_text()
  titles<-str_trim(titles)
  links <- tem %>% html_nodes("div.box_subtab ul li a") %>% html_attr("href")
  links <- gsub(paste0("/breakingnews",categoryUrl),"",links)
  urls <- data.frame(sub_cate_name=titles,url=links,stringsAsFactors = F)
  urls <- urls[-1,]
  return(urls)
  
}