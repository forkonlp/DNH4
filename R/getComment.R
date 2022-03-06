#' Get Comment
#'
#' Get daum news comments
#'
#' @param turl like 'http://v.media.daum.net/v/20161117210603961'.
#' @param limit is number of comment. Default is 10.
#' @param offset is comment number of start. Default is 0.
#' @param parentId Default is 0.
#' @param sort you can select RECOMMEND, LATEST. RECOMMEND is Default.
#' @param type return type. Default is tibble. It may sometimes warn message.
#' @return a [tibble][tibble::tibble-package]
#' @export
getComment <-
  function(turl,
           limit = 10,
           offset = 0,
           parentId = 0,
           sort = c("RECOMMEND", "LATEST"),
           type = c("df", "list")) {
    auth <- getCommentAuth(turl)
    
    comment_info <- getCommentInfo(turl, auth)
    
    dat <- getCommentData(comment_info,
                          limit,
                          offset,
                          parentId,
                          sort,
                          type)
    return(dat)
  }

#' Get All Comment
#'
#' Get daum news comments
#'
#' @param turl like 'http://v.media.daum.net/v/20161117210603961'.
#' @param sort you can select RECOMMEND, LATEST. RECOMMEND is Default.
#' @return a [tibble][tibble::tibble-package]
#' @importFrom httr GET content add_headers
#' @importFrom rvest html_nodes html_attr
#' @export
getAllComment <-
  function(turl, sort = c("RECOMMEND", "LATEST")) {
    auth <- getCommentAuth(turl)
    comment_info <- getCommentInfo(turl, auth)
    max_offset <-
      round(comment_info$commentCount - comment_info$childCount, -2) / 100 + 1
    
    dat <-
      lapply((0:max_offset) * 100, function(x)
        getCommentData(comment_info,
                       100,
                       x,
                       0,
                       sort,
                       "df"))
  
    dat <- do.call(rbind, dat)
    return(dat)
  }



getCommentAuth <- function(turl) {
  client_id <- httr::GET(turl)
  client_id <- httr::content(client_id)
  client_id <- rvest::html_nodes(client_id, ".alex-area")
  client_id <- rvest::html_attr(client_id, "data-client-id")
  
  tar <-
    paste0(
      "https://alex.daum.net/oauth/token?grant_type=alex_credentials&client_id=",
      client_id
    )
  
  ad <- httr::add_headers("Referer" = turl)
  auth <- httr::GET(tar, ad)
  auth <- httr::content(auth)
  return(auth)
}

getCommentInfo <- function(turl, auth) {
  post_id <- strsplit(turl, "/")[[1]]
  post_id <- post_id[length(post_id)]
  
  tar <-
    paste0("https://comment.daum.net/apis/v1/ui/single/main/@", post_id)
  ad <-
    httr::add_headers("Authorization" = paste0("Bearer ", auth$access_token))
  comment_info <- httr::GET(tar, ad)
  comment_info <- httr::content(comment_info, encoding = "UTF-8")
  return(comment_info$post)
}

getCommentData <- function(comment_info,
                           limit,
                           offset,
                           parentId,
                           sort,
                           type) {
  tar <-
    paste0(
      "http://comment.daum.net/apis/v1/posts/",
      comment_info$id,
      "/comments?parentId=",
      parentId,
      "&offset=",
      offset,
      "&limit=",
      limit,
      "&sort=",
      sort[1]
    )
  
  dat <- httr::GET(tar)
  dat <- httr::content(dat)
  if (type[1] == "df" & length(dat) != 0) {
    dat <- CommentListtoDf(dat)
  }
  if (identical(dat, list())) {
    dat <- c()
  }
  return(dat)
}

CommentListtoDf <- function(dat) {
  chk <- unlist(lapply(dat, function(x) x$icon))
  if (!is.null(chk)) {
    dat <- lapply(dat, function(x) {
      x[c("icon")] <- NULL
      x
    })
  }
  tem <- do.call(rbind, dat)
  user <-
    lapply(tem[, "user"], function(x) {
      if (length(x) == 0) {
        x <- emptyUser()
      }
      x[c("url", "icon", "description")] <- NULL
      x
    })
  user <- do.call(rbind, user)
  tem <- as.data.frame(tem)
  user <- as.data.frame(user)
  names(user) <- paste0("user_", names(user))
  dat <- cbind(tem[, c(1, 3:15)], user)
  if (nrow(dat) != 1) {
    dat <- tidyr::unnest(dat, cols = colnames(dat))
  }
  return(dat)
}

emptyUser <- function() {
  list(
    id = c(),
    status = c(),
    type = c(),
    flags = c(),
    icon = c(),
    url = c(),
    username = c(),
    roles = c(),
    providerId = c(),
    providerUserId = c(),
    displayName = c(),
    description = c(),
    commentCount = c()
  )
}
