#' Get Url List
#'
#' Get daum news titles and links from target url.
#'
#' @param turl is target url daum news.
#' @return a [tibble][tibble::tibble-package](news_title, news_links).
#' @export
#' @importFrom rvest read_html html_nodes html_text html_attr
#' @importFrom tibble tibble
getUrlList <- function(turl = url) {
  hobj <- rvest::read_html(turl)
  hobj_nodes <- rvest::html_nodes(hobj, "strong.tit_thumb a")
  news_title <- rvest::html_text(hobj_nodes)
  Encoding(news_title) <- "UTF-8"
  news_links <- rvest::html_attr(hobj_nodes, "href")
  
  news_lists <-
    tibble::tibble(
      news_title = news_title,
      news_links = news_links
    )
  
  return(news_lists)
}
