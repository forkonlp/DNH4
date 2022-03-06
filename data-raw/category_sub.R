## code to prepare `category_sub` dataset goes here

library(DNH4)

mc <- getMainCategory()

category_sub <- c()
for (i in 1:nrow(mc)) {
  tt <- getSubCategory(mc[i, "url"], fresh = TRUE)
  main_cate_name <- mc[i, "cate_name"]
  if (nrow(tt) == 0) {
    next
  }
  tt <- cbind(main_cate_name, tt)
  category_sub <- rbind(sub, tt)
}

usethis::use_data(category_sub, overwrite = TRUE, internal = TRUE)
