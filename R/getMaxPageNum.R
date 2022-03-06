#' Get Max Page Number
#'
#' @param turl is target url include breakingnews, category url, date without regDate like below.
#'             'https://news.daum.net/breakingnews/politics/administration?regDate=20220305'
#' @return Get numeric
#' @export
#' @importFrom rvest read_html html_node html_attr

getMaxPageNum <- function(turl = url) {
  hobj <- rvest::read_html(turl)
  ifnext <- rvest::html_node(hobj, "span.inner_paging a.btn_next")
  while (class(ifnext) == "xml_node") {
    nextUrl <- rvest::html_attr(ifnext, "href")
    nextUrl <- paste0("http://media.daum.net", nextUrl)
    hobj <- rvest::read_html(nextUrl)
    ifnext <- rvest::html_node(hobj, "span.inner_paging a.btn_next")
  }
  hobj_nodes <- rvest::html_nodes(hobj, "a.num_page")
  maxPageNum <- rvest::html_text(hobj_nodes)
  maxPageNum <- as.numeric(maxPageNum)
  maxPageNum <- maxPageNum[length(maxPageNum)]
  return(maxPageNum)
}
