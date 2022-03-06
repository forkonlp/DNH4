## code to prepare `category_sub` dataset goes here

library(DNH4)

category_main <- getMainCategory()

category_sub <- c()
for (i in 1:nrow(category_main)) {
  tt <- getSubCategory(category_main[i, "url"], fresh = TRUE)
  main_cate_name <- category_main[i, "cate_name"]
  if (nrow(tt) == 0) {
    next
  }
  tt <- cbind(main_cate_name, tt)
  category_sub <- rbind(category_sub, tt)
}

usethis::use_data(category_main, category_sub, overwrite = TRUE, internal = TRUE)
