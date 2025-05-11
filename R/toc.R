suppressPackageStartupMessages({
  library(readr)
  library(stringr)
  library(dplyr)
  library(glue)
})

update_typora_and_github_toc <- function(file = "README.md") {
  # Đọc file gốc
  lines <- read_lines(file)
  
  # Xoá các dòng tiêu đề MỤC LỤC, [TOC], và khối TOC cũ
  lines <- lines[!str_detect(lines, "^#{0,6}\\s*MỤC LỤC\\s*$") & trimws(lines) != "[TOC]"]
  toc_start <- which(str_detect(lines, "<!-- TOC start -->"))
  toc_end   <- which(str_detect(lines, "<!-- TOC end -->"))
  if (length(toc_start) > 0 && length(toc_end) > 0 && toc_end >= toc_start) {
    lines <- lines[-c(toc_start:toc_end)]
  }
  
  # Tìm các heading cấp 1–3 để làm TOC
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
  
  # Khối TOC gồm cả cho Typora ([TOC]) và GitHub (HTML comment)
  toc_full <- c(
    "MỤC LỤC",
    "[TOC]",
    "<!-- TOC start -->",
    headings$toc_line,
    "<!-- TOC end -->"
  )
  
  # Chèn TOC + dòng trắng
  full_lines <- c(toc_full, "", lines)
  
  # ✅ Thêm 2 dấu cách cuối mỗi dòng không trống và không phải tiêu đề markdown
  full_lines <- sapply(full_lines, function(line) {
    if (grepl("^\\s*$", line) || grepl("^#{1,6}\\s", line)) {
      line
    } else {
      paste0(line, "  ")  # Thêm hai dấu cách để xuống dòng mềm trong GitHub
    }
  })
  
  # Ghi lại vào file
  write_lines(full_lines, file)
  cat("✅ Đã chèn TOC và xử lý xuống dòng cho GitHub vào", file, "\n")
}

# 👉 Chạy hàm
update_typora_and_github_toc()
