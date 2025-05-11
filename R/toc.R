suppressPackageStartupMessages({
  library(readr)
})

update_plain_typora_toc <- function(file = "README.md") {
  # Đọc file gốc
  lines <- read_lines(file)
  
  # Xoá mọi dòng chứa "MỤC LỤC" (dù có tiêu đề hay không) và dòng [TOC]
  lines_clean <- lines[
    !grepl("^#{0,6}\\s*MỤC LỤC\\s*$", lines, ignore.case = TRUE) &
      trimws(lines) != "[TOC]"
  ]
  
  # Khối TOC mới không có tiêu đề Markdown
  toc_block <- c("MỤC LỤC", "[TOC]")
  
  # Chèn vào đầu
  new_lines <- c(toc_block, lines_clean)
  
  # Ghi lại vào file mà không thêm dòng trắng thừa
  writeLines(new_lines, file, useBytes = TRUE)
  
  cat("✅ Đã chèn TOC (MỤC LỤC + [TOC]) vào đầu README.md\n")
}

# 👉 Thực thi
update_plain_typora_toc()
