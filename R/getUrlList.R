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
  news_title <- gsub("\\s+(\uc870\uc120\ube44\uc988|\ub274\uc2a41|\uc5f0\uac74\ub274\uc2a4|MBN|YTN|\uc911\uc559\uc77c\ubcf4|\ub3d9\uc544\uc77c\ubcf4|\ud55c\uaca8\ub808|\uacbd\ud5a5\uc2dc\ubb38|\uc11c\uc6b8\uc2dc\ubb38|\ud55c\uad6d\uacbd\uc801|\ub9e4\uc77c\uacbd\uc801|\uc2dc\uc0acIN|\uc8fc\uac04\ub3d9\uc544|\uc2dc\uc0ac\ub9e4\uac70\uc9c4|\uc5ec\uc131\uc2dc\ubb38|\uc11c\uc6b8\uc2dc\ubb38|[\uac00-\ud7a3])\\s+\\d+\ubd84? \uc804\\s*$", "", news_title)
  # Remove trailing patterns with source prefix
  news_title <- gsub("\\s*\\([\uac00-\ud7a3]+=[\uac00-\ud7a3]+\\)\\s*[\uac00-\ud7a3]+(?:\\s+\uae30\uc790)?\\s*=.*$", "", news_title)
  news_title <- gsub("\\s*\\(\uc885\ud569\\)\\s*.*$", "", news_title)
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
