suppressPackageStartupMessages({
  library(readr)
  library(stringr)
  library(dplyr)
  library(glue)
})

update_typora_and_github_toc <- function(file = "README.md") {
  # 1. Đọc toàn bộ nội dung
  lines <- read_lines(file)
  
  # 2. Xoá các dòng TOC cũ (cả tiêu đề MỤC LỤC, [TOC], và <!-- TOC ... -->)
  lines <- lines[!str_detect(lines, "^#{0,6}\\s*MỤC LỤC\\s*$") & trimws(lines) != "[TOC]"]
  toc_start <- which(str_detect(lines, "<!-- TOC start -->"))
  toc_end   <- which(str_detect(lines, "<!-- TOC end -->"))
  if (length(toc_start) > 0 && length(toc_end) > 0) {
    lines <- lines[-c(toc_start:toc_end)]
  }
  
  # 3. Tìm các heading cấp 1-3
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
        stringi::stri_trans_general("Latin-ASCII") %>%
        str_replace_all("[^a-z0-9\\s-]", "") %>%
        str_replace_all("\\s+", "-")
    ) %>%
    mutate(
      indent = case_when(
        level == 1 ~ "",
        level == 2 ~ "  ",
        level == 3 ~ "    ",
        TRUE ~ ""
      ),
      toc_line = glue("{indent}- [{title}](#{anchor})")
    )
  
  # 4. Tạo khối TOC mới
  toc_full <- c(
    "MỤC LỤC",
    "[TOC]",
    "<!-- TOC start -->",
    headings$toc_line,
    "<!-- TOC end -->"
  )
  
  # 5. Chèn lại TOC vào đầu
  lines <- c(toc_full, "", lines)
  
  # 6. Thêm dòng "go to TOC" sau mỗi đoạn văn
  is_paragraph_line <- function(line) {
    str_detect(line, "[[:alpha:]]") && !str_starts(line, "#") && !str_starts(line, "- ")
  }
  
  lines_augmented <- c()
  for (i in seq_along(lines)) {
    line <- lines[i]
    lines_augmented <- c(lines_augmented, line)
    
    is_para <- is_paragraph_line(line)
    is_next_blank_or_end <- i == length(lines) || str_trim(lines[i + 1]) == ""
    
    if (is_para && is_next_blank_or_end) {
      lines_augmented <- c(lines_augmented, "*go to [MỤC LỤC](#muc-luc)*", "")
    }
  }
  
  # 7. Ghi đè vào file
  write_lines(lines_augmented, file)
  cat("✅ Đã cập nhật TOC và thêm liên kết 'go to TOC' vào:", file, "\n")
}

# 👉 Thực thi
update_typora_and_github_toc()
