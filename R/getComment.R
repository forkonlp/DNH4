#' Get Comment
#'
#' Get daum news comments
#'
#' @param turl like 'http://v.media.daum.net/v/20161117210603961'.
#' @param limit is number of comment. defult is 10. You can set "all" to get all comments. 
#' @param parentId defult is 0.
#' @param sort you can select RECOMMEND, LATEST. RECOMMEND is defult.
#' @param type return type. Defult is data.frame. It may sometimes warnning message.
#' @return Get data.frame.
#' @export
#' @importFrom httr GET content add_headers
#' @importFrom xml2 read_html
#' @importFrom rvest html_nodes html_attr

getComment <-
  function(turl = url,
           limit = 10,
           parentId = 0,
           sort = c("RECOMMEND", "LATEST"),
           type = c("df","list")) {
    client_id <- httr::GET(turl)
    client_id <- httr::content(client_id)
    client_id <- rvest::html_nodes(client_id, ".alex-area")
    client_id <- rvest::html_attr(client_id, "data-client-id")
    
    tar <-
      paste0("https://comment.daum.net/auth/credential?client_id=",
             client_id)
    ad <- httr::add_headers("Referer" = turl)
    auth <- httr::GET(tar, ad)
    auth <- httr::content(auth)
    
    post_id <- strsplit(turl, "/")[[1]]
    post_id <- post_id[length(post_id)]
    
    tar <-
      paste0("http://comment.daum.net/apis/v1/posts/@", post_id)
    ad <-
      httr::add_headers("Authorization" = paste0("Bearer ", auth$access_token))
    comment_info <- httr::GET(tar, ad)
    comment_info <- httr::content(comment_info)
    
    if(limit == "all"){
      limit <- comment_info$commentCount
    }
    
    tar <-
      paste0(
        "http://comment.daum.net/apis/v1/posts/",
        comment_info$id,
        "/comments?parentId=",
        parentId,
        "&offset=0&limit=",
        limit,
        "&sort=",
        sort[1]
      )
    
    dat <- httr::GET(tar)
    dat <- httr::content(dat)
    if (type[1] == "df"){
      tem <- do.call(rbind, dat)
      user <- do.call(rbind, tem[,"user"])
      tem <- as.data.frame(tem)
      user <- as.data.frame(user)
      names(user) <- paste0("user_", names(user))
      dat <- cbind(tem[,c(1,3:15)], user)
    }
    return(dat)
    
  }