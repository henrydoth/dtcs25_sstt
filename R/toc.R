suppressPackageStartupMessages({
  library(readr)
  library(stringr)
  library(dplyr)
  library(glue)
  library(purrr)
})

update_typora_and_github_toc <- function(file = "README.md") {
  # Đọc file
  lines <- read_lines(file)
  
  # Xoá các dòng TOC cũ
  lines <- lines[!str_detect(lines, "^#{0,6}\\s*MỤC LỤC\\s*$") & trimws(lines) != "[TOC]"]
  toc_start <- which(str_detect(lines, "<!-- TOC start -->"))
  toc_end   <- which(str_detect(lines, "<!-- TOC end -->"))
  if (length(toc_start) > 0 && length(toc_end) > 0) {
    lines <- lines[-(toc_start:toc_end)]
  }
  
  # Thêm dòng trắng sau các heading nếu chưa có
  i <- 1
  while (i < length(lines)) {
    if (str_detect(lines[i], "^#{1,6}\\s+") && lines[i+1] != "") {
      lines <- append(lines, "", after = i)
    }
    i <- i + 1
  }
  
  # Lấy các heading cấp 1–3
  headings <- tibble(
    line = lines,
    linenum = seq_along(lines)
  ) %>%
    filter(str_detect(line, "^#{1,3} ")) %>%
    mutate(
      level = str_count(str_extract(line, "^#+")),
      title = str_trim(str_remove(line, "^#{1,3}\\s+")),
      anchor = title %>%
        str_to_lower() %>%
        str_replace_all("[^[:alnum:]\\s]", "") %>%
        str_replace_all("\\s+", "-"),
      indent = case_when(
        level == 1 ~ "",
        level == 2 ~ "  ",
        level == 3 ~ "    ",
        TRUE ~ ""
      ),
      toc_line = glue("{indent}- [{title}](#{anchor})")
    )
  
  # Tạo khối TOC mới
  toc_full <- c(
    "MỤC LỤC",
    "[TOC]",
    "<!-- TOC start -->",
    headings$toc_line,
    "<!-- TOC end -->"
  )
  
  # Ghép lại toàn bộ nội dung
  new_lines <- c(toc_full, "", lines)
  
  # Ghi ra file
  write_lines(new_lines, file, sep = "\n")
  cat("✅ Đã cập nhật TOC vào", file, "\n")
}

# 👉 Gọi hàm
update_typora_and_github_toc()
