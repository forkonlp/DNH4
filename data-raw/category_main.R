## code to prepare `category_main` dataset goes here
library(DNH4)

category_main <- getMainCategory(fresh = TRUE)

usethis::use_data(category_main, overwrite = TRUE, internal = TRUE)
