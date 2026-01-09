#' Get Max Page Number
#'
#' Gets the maximum page number for a given category URL.
#'
#' @param turl is target url include breakingnews, category url, date without regDate like below.
#'             'https://news.daum.net/breakingnews/politics/administration?regDate=20220305'
#' @return Get numeric (maximum page number)
#' @export
#' @importFrom rvest read_html html_nodes html_text
getMaxPageNum <- function(turl = url) {
  tryCatch({
    hobj <- rvest::read_html(turl)

    # Find the total page element (class: total_page)
    hobj_nodes <- rvest::html_nodes(hobj, ".total_page")
    if (length(hobj_nodes) > 0) {
      total_text <- rvest::html_text(hobj_nodes[1])
      total_pages <- as.numeric(total_text)
      if (!is.na(total_pages) && total_pages > 0) {
        return(total_pages)
      }
    }

    # Fallback: try to extract from count_page text (e.g., "현재 페이지 1 / 전체 페이지 3")
    hobj_nodes <- rvest::html_nodes(hobj, ".count_page")
    if (length(hobj_nodes) > 0) {
      count_text <- rvest::html_text(hobj_nodes[1])
      # Extract the last number which is the total pages
      total_match <- regmatches(count_text, regexpr("[0-9]+$", count_text))
      if (length(total_match) > 0) {
        total_pages <- as.numeric(total_match[length(total_match)])
        if (!is.na(total_pages) && total_pages > 0) {
          return(total_pages)
        }
      }
    }

    return(1)
  }, error = function(e) {
    return(1)
  })
}
