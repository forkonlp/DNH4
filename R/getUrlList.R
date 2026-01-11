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
  hobj_nodes <- rvest::html_nodes(hobj, "a")

  # Get all links and filter for news article links
  all_href <- rvest::html_attr(hobj_nodes, "href")
  all_text <- rvest::html_text(hobj_nodes)

  # Filter for news article links (contain /v/ in URL)
  news_mask <- grepl("/v/", all_href, fixed = TRUE)

  news_title <- all_text[news_mask]
  news_links <- all_href[news_mask]

  # Clean up titles
  news_title <- gsub("\\s+(조선비즈|뉴스1|연합뉴스|MBN|YTN|중앙일보|동아일보|한겨레|경향신문|서울신문|한국경제|매일경제|시사IN|주간동아|시사매거진|여성신문|서울신문|[가-힣A-Za-z]+)\\s+\\d+분? 전\\s*$", "", news_title)
  # Remove trailing patterns with source prefix
  news_title <- gsub("\\s*\\([가-힣A-Za-z]+=[가-힣A-Za-z]+\\)\\s*[가-힣A-Za-z]+(?:\\s+기자)?\\s*=.*$", "", news_title)
  # Remove trailing "(종합)" pattern
  news_title <- gsub("\\s*\\(종합\\)\\s*.*$", "", news_title)
  # 4. For longer texts (with article content), truncate to 150 chars
  news_title <- sapply(news_title, function(x) {
    if (nchar(x) > 150) {
      x <- substr(x, 1, 150)
    }
    trimws(x)
  })

  news_lists <-
    tibble::tibble(
      news_title = news_title,
      news_links = news_links
    )

  return(news_lists)
}
