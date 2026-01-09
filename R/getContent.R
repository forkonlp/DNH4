#' Get Content
#'
#' Get daum news content from links.
#'
#' @param turl is daum news link.
#' @return a [tibble][tibble::tibble-package] (url,datetime,press,title,content).
#' @importFrom rvest read_html html_nodes html_text html_attr
#' @importFrom httr GET content user_agent
#' @export
getContent <- function(turl = url) {
  if (!identical(turl, character(0))) {
    tem <-
      httr::GET(turl,
                httr::user_agent("DNH4 by chanyub.park <mrchypark@gmail.com>"))
    if (tem$status_code == 200) {
      # Support both URL formats: https://v.daum.net/v and https://news.v.daum.net/v
      if (grepl("^https://v\\.daum\\.net/v", tem$url) || grepl("^https://news\\.v\\.daum\\.net/v", tem$url)) {
        hobj <- rvest::read_html(tem)

        # Title
        hobj_nodes <-
          rvest::html_nodes(hobj, "div.head_view h3.tit_view")
        title <- rvest::html_text(hobj_nodes)
        Encoding(title) <- "UTF-8"

        # Datetime - handle both old format (2026.01.09.) and new format (2026. 1. 9. 17:36)
        hobj_nodes <-
          rvest::html_nodes(hobj, "span.info_view span.txt_info span.num_date, span.num_date")
        datetime <- rvest::html_text(hobj_nodes)
        Encoding(datetime) <- "UTF-8"
        
        # Clean datetime: remove non-numeric characters except spaces, dots, and colons
        datetime <- gsub("[^0-9.:]", " ", datetime)
        datetime <- trimws(datetime)
        datetime <- datetime[nchar(datetime) > 0]
        
        # Convert to standard format
        # Old format: "2026.01.09." -> "2026-01-09"
        # New format: "2026. 1. 9. 17:36" -> "2026-01-09 17:36"
        datetime <- gsub("\\.", "", datetime, fixed = TRUE)
        datetime <- gsub("  ", " ", datetime)
        datetime <- trimws(datetime)
        
        # Parse and format
        parts <- strsplit(datetime, " ")[[1]]
        if (length(parts) >= 3) {
          year <- parts[1]
          month <- sprintf("%02d", as.numeric(parts[2]))
          day <- sprintf("%02d", as.numeric(parts[3]))
          time_part <- if (length(parts) >= 4) parts[4] else "00:00"
          datetime <- paste0(year, "-", month, "-", day, " ", time_part)
        } else {
          datetime <- NA
        }
        
        datetime <- as.POSIXlt(datetime, format = "%Y-%m-%d %H:%M")

        if (length(datetime) == 1) {
          edittime <- datetime[1]
        }
        if (length(datetime) == 2) {
          edittime <- datetime[2]
          datetime <- datetime[1]
        }
        if (!exists("edittime")) {
          edittime <- NA
        }

        # Press (legacy selector, may return empty for new website design)
        hobj_nodes <-
          rvest::html_nodes(hobj, "div.head_view em.info_cp a.link_cp img")
        press <- rvest::html_attr(hobj_nodes, "alt")
        Encoding(press) <- "UTF-8"
        if (length(press) == 0) {
          press <- NA_character_
        }

        # Content
        hobj_nodes <-
          rvest::html_nodes(hobj, 'div.article_view section p,div[dmcf-ptype="general"]')
        content <- rvest::html_text(hobj_nodes)
        Encoding(content) <- "UTF-8"
        content <- trimws(content)
        content <- gsub("\r?\n|\r", " ", content)
        content <- paste0("<p>", content, "<p>")
        content <- paste0(content, collapse = " ")
        content <- gsub("<p> <p>", " ", content)
        content <- gsub("<p>", "", content)

        newsInfo <-
          data.frame(
            url = turl,
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
          url = turl,
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
