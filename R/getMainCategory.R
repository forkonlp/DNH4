#' Get News Main Categories
#'
#' Get daum news main category names and ids recently.
#'
#' @param fresh If TRUE, get data from internet. 
#'              Default is FALSE which is return with cache.
#' @return Get data.frame(chr:cate_name, chr:url).
#' @export
#' @importFrom rvest read_html html_nodes html_text html_attr
getMainCategory <- function(fresh = FALSE) {
  if (!fresh) {
    return(category_main)
  }
  root <- "http://media.daum.net/breakingnews"
  hobj <- rvest::read_html(root)
  hobj_nodes <-
    rvest::html_nodes(hobj, "div#mArticle ul.tab_nav li a")
  titles <- rvest::html_text(hobj_nodes)
  titles <- trimws(titles)
  links <- rvest::html_attr(hobj_nodes, "href")
  links <- gsub("/breakingnews/", "", links)
  urls <-
    data.frame(cate_name = titles,
               url = links,
               stringsAsFactors = F)
  urls <- urls[-1, ]
  return(urls)
}
