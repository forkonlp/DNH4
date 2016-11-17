#' Get Max Page Number
#'
#' @param turl is target url include breakingnews, category url, date without regDate like below.
#'             'http://media.daum.net/breakingnews/politics/president?regDate=20161104'
#' @return Get numeric
#' @export
#' @import xml2
#' @import rvest

getMaxPageNum <- function(turl=url) {
  
  tem <- read_html(turl)
  ifnext <- tem %>% html_node("span.inner_paging a.btn_next")
  while(class(ifnext)=="xml_node"){
    nextUrl <- ifnext %>% html_attr("href")
    nextUrl <- paste0("http://media.daum.net",nextUrl)
    tem <- read_html(nextUrl)
    ifnext <- tem %>% html_node("span.inner_paging a.btn_next")
  }
  maxPageNum <- tem %>% html_nodes("a.num_page") %>% html_text() %>% as.numeric
  maxPageNum <- maxPageNum[length(maxPageNum)]
  return(maxPageNum)
  
}