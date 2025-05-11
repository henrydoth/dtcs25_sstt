# 📌 Script: Tạo TOC chuẩn GitHub/Typora cho README.md
suppressPackageStartupMessages({
  library(stringi)
  library(dplyr)
  library(readr)
})

# 👉 Hàm chuyển tiêu đề thành anchor
make_anchor <- function(text) {
  text %>%
    stri_trans_general("Latin-ASCII") %>%       # bỏ dấu
    tolower() %>%
    gsub("[^a-z0-9 -]", "", .) %>%              # bỏ ký tự đặc biệt
    gsub("[[:space:]]+", "-", .) %>%            # thay khoảng trắng = -
    gsub("-+", "-", .)                          # bỏ trùng dấu gạch
}

# 👉 Hàm tạo TOC từ file markdown
create_toc_from_readme <- function(file) {
  lines <- readLines(file, warn = FALSE)
  
  toc_lines <- c("<!-- TOC start -->")
  
  for (line in lines) {
    if (grepl("^#{1,3} ", line)) {
      level <- attr(regexpr("^#+", line), "match.length")
      heading_text <- gsub("^#+\\s*", "", line)
      anchor <- make_anchor(heading_text)
      
      indent <- switch(
        as.character(level),
        "1" = "- ",
        "2" = "  - ",
        "3" = "    - ",
        ""
      )
      
      toc_lines <- c(toc_lines, sprintf("%s[%s](#%s)", indent, heading_text, anchor))
    }
  }
  
  toc_lines <- c(toc_lines, "<!-- TOC end -->")
  return(toc_lines)
}

# 👉 Đường dẫn đến README
readme_file <- "README.md"

# 👉 Sinh TOC mới
toc_lines <- create_toc_from_readme(readme_file)
readme_lines <- readLines(readme_file, warn = FALSE)

# 👉 Tìm và thay TOC cũ nếu có
toc_start <- grep("<!-- TOC start -->", readme_lines)
toc_end <- grep("<!-- TOC end -->", readme_lines)

if (length(toc_start) == 1 && length(toc_end) == 1 && toc_start < toc_end) {
  new_readme <- c(
    readme_lines[1:(toc_start - 1)],
    toc_lines,
    readme_lines[(toc_end + 1):length(readme_lines)]
  )
} else {
  new_readme <- c(
    readme_lines[1],
    "",
    toc_lines,
    "",
    readme_lines[2:length(readme_lines)]
  )
}

writeLines(new_readme, readme_file)
cat("✅ TOC đã được cập nhật trong README.md, chuẩn GitHub ✅\n")
