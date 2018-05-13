#' Get News Sub Categories
#'
#' Get daum news sub category names and urls recently.
#'
#' @param categoryUrl Main category url in daum news. Only 1 value is passible. Default is society.
#' @return Get data.frame(chr:sub_cate_name, chr:url).
#' @export
#' @importFrom xml2 read_html
#' @importFrom rvest html_nodes html_text html_attr

getSubCategory <- function(categoryUrl="society") {
  
  root <- paste0("http://media.daum.net/breakingnews/",categoryUrl)
  hobj <- read_html(root)
  hobj_nodes <- html_nodes(hobj, "div.box_subtab ul li a") 
  titles <- html_text(hobj_nodes)
  titles <- trimws(titles)
  links <- html_attr(hobj_nodes, "href")
  links <- gsub(paste0("/breakingnews",categoryUrl),"",links)
  urls <- data.frame(sub_cate_name=titles,url=links,stringsAsFactors = F)
  urls <- urls[-1,]
  return(urls)
  
}