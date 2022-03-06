#' Get News Sub Categories
#'
#' Get daum news sub category names and urls recently.
#'
#' @param categoryUrl Main category url in daum news. Only 1 value is passible. 
#'                    Default is society.
#' @param fresh If TRUE, get data from internet. 
#'              Default is FALSE which is return with cache.
#' @return Get data.frame(chr:sub_cate_name, chr:url).
#' @export
#' @importFrom rvest read_html html_nodes html_text html_attr
#' @examples
#'   getSubCategory()
#'   getSubCategory("politics")
getSubCategory <- function(categoryUrl = "society", fresh = FALSE) {
  if (!fresh) {
    category_sub <-
      category_sub[grepl(categoryUrl, category_sub$url), c("sub_cate_name", "url")]
    return(category_sub)
  }
  root <- paste0("https://news.daum.net/breakingnews/", categoryUrl)
  hobj <- rvest::read_html(root)
  hobj_nodes <- rvest::html_nodes(hobj, "div.box_subtab ul li a")
  titles <- rvest::html_text(hobj_nodes)
  titles <- trimws(titles)
  links <- rvest::html_attr(hobj_nodes, "href")
  links <- gsub(paste0("/breakingnews", categoryUrl), "", links)
  urls <-
    data.frame(
      sub_cate_name = titles,
      url = links,
      stringsAsFactors = F
    )
  urls <- urls[-1, ]
  return(urls)
}
