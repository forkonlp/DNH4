#' Get Content
#'
#' Get daum news content from links.
#'
#' @param url is daum news link.
#' @return Get data.frame(url,datetime,press,title,content).
#' @export
#' @import RCurl
#' @import xml2
#' @import rvest
#' @import stringr

getContent <- function(url = url) {
  
  if(!identical(url,character(0))){
    if (RCurl::url.exists(url)) {
      veri <- curlGetHeaders(url, redirect = TRUE,verify = TRUE)
      veri <- veri[grep("Location",veri)]
      if(identical(veri,character(0))){
      
        tem <- read_html(url)
        title <- tem %>% html_nodes("div.head_view h3.tit_view") %>% html_text()
        Encoding(title) <- "UTF-8"
        
        datetime <- tem %>% html_nodes("span.info_view span.txt_info") %>% html_text()
        Encoding(datetime) <- "UTF-8"
        datetime <- datetime[nchar(datetime)==19]
        datetime <- str_sub(datetime,4,nchar(datetime))
        datetime <- gsub("\\.","-",datetime)
        datetime <- as.POSIXlt(datetime)
        
        if (length(datetime) == 1) {
          edittime <- datetime[1]
        }
        if (length(datetime) == 2) {
          edittime <- datetime[2]
          datetime <- datetime[1]
        }
        
        press <- tem %>% html_nodes("div.head_view em.info_cp a.link_cp img") %>% html_attr("alt")
        Encoding(press) <- "UTF-8"
        
        content <- tem %>% html_nodes("div.article_view section p") %>% html_text()
        Encoding(content) <- "UTF-8"
        content <- str_trim(content,side="both")
        content <- gsub("\r?\n|\r", " ", content)
        # content[c(-length(content),-(length(content)-1))]
        content <- paste0("<p>",content,"<p>")
        content <- paste0(content, collapse = " ")
        
        newsInfo <- data.frame(url = url, datetime = datetime, edittime = edittime, press = press, title = title, content = content, stringsAsFactors = F)
      } else {
        newsInfo <- data.frame(url = "no news links", datetime = "no news links", edittime = "no news links", press = "no news links", title = "no news links", content = "no news links",
                               stringsAsFactors = F)
        return(newsInfo)
      }
      
    } else {
      
      newsInfo <- data.frame(url = url, datetime = "page is moved.", edittime = "page is moved.", press = "page is moved.", title = "page is moved.", content = "page is moved.",
                             stringsAsFactors = F)
      
    }
    return(newsInfo)
  } else { print("no news links")
    
    newsInfo <- data.frame(url = "no news links", datetime = "no news links", edittime = "no news links", press = "no news links", title = "no news links", content = "no news links",
                           stringsAsFactors = F)
    return(newsInfo)
  }
}
