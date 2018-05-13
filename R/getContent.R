#' Get Content
#'
#' Get daum news content from links.
#'
#' @param turl is daum news link.
#' @return Get data.frame(url,datetime,press,title,content).
#' @export
#' @importFrom xml2 read_html
#' @importFrom rvest html_nodes html_text html_attr
#' @importFrom httr GET content user_agent

getContent <- function(turl = url) {
  if (!identical(url, character(0))) {
    tem <-
      httr::GET(turl,
                httr::user_agent("DNH4 by chanyub.park <mrchypark@gmail.com>"))
    if (tem$status_code == 200) {
      if (grepl("^http://v.media.daum.net/v", tem$url)) {
        hobj <- xml2::read_html(tem)
        hobj_nodes <-
          rvest::html_nodes(hobj, "div.head_view h3.tit_view")
        title <- rvest::html_text(hobj_nodes)
        Encoding(title) <- "UTF-8"
        
        hobj_nodes <-
          rvest::html_nodes(hobj, "span.info_view span.txt_info")
        datetime <- rvest::html_text(hobj_nodes)
        Encoding(datetime) <- "UTF-8"
        datetime <- datetime[nchar(datetime) == 20]
        datetime <- gsub("[^0-9.: ]","",datetime)
        datetime <- trimws(datetime)
        datetime <-
          gsub("([0-9]{4})\\.([0-9]{2})\\.([0-9]{2})\\.",
               "\\1-\\2-\\3",
               datetime)
        datetime <- as.POSIXlt(datetime)
        
        if (length(datetime) == 1) {
          edittime <- datetime[1]
        }
        if (length(datetime) == 2) {
          edittime <- datetime[2]
          datetime <- datetime[1]
        }
        
        hobj_nodes <-
          rvest::html_nodes(hobj, "div.head_view em.info_cp a.link_cp img")
        press <- rvest::html_attr(hobj_nodes, "alt")
        Encoding(press) <- "UTF-8"
        
        hobj_nodes <-
          rvest::html_nodes(hobj, "div.article_view section p")
        content <- rvest::html_text(hobj_nodes)
        Encoding(content) <- "UTF-8"
        content <- trimws(content)
        content <- gsub("\r?\n|\r", " ", content)
        content <- paste0("<p>", content, "<p>")
        content <- paste0(content, collapse = " ")
        content <- gsub("<p><p> ", "", content)
        
        newsInfo <-
          data.frame(
            url = url,
            datetime = datetime,
            edittime = edittime,
            press = press,
            title = title,
            content = content,
            stringsAsFactors = F
          )
      } else {
        newsInfo <-
          data.frame(
            url = "no news links",
            datetime = "no news links",
            edittime = "no news links",
            press = "no news links",
            title = "no news links",
            content = "no news links",
            stringsAsFactors = F
          )
        return(newsInfo)
      }
      
    } else {
      newsInfo <-
        data.frame(
          url = url,
          datetime = "page is moved.",
          edittime = "page is moved.",
          press = "page is moved.",
          title = "page is moved.",
          content = "page is moved.",
          stringsAsFactors = F
        )
      
    }
    return(newsInfo)
  } else {
    print("no news links")
    
    newsInfo <-
      data.frame(
        url = "no news links",
        datetime = "no news links",
        edittime = "no news links",
        press = "no news links",
        title = "no news links",
        content = "no news links",
        stringsAsFactors = F
      )
    return(newsInfo)
  }
}
