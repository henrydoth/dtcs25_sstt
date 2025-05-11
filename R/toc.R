suppressPackageStartupMessages({
  library(readr)
  library(stringr)
  library(dplyr)
  library(glue)
})

update_typora_and_github_toc <- function(file = "README.md") {
  # Đọc file
  lines <- read_lines(file)
  
  # Xoá mọi dòng MỤC LỤC, [TOC], <!-- TOC start --> ... <!-- TOC end -->
  lines <- lines[!str_detect(lines, "^#{0,6}\\s*MỤC LỤC\\s*$") & trimws(lines) != "[TOC]"]
  toc_start <- which(str_detect(lines, "<!-- TOC start -->"))
  toc_end   <- which(str_detect(lines, "<!-- TOC end -->"))
  if (length(toc_start) > 0 && length(toc_end) > 0) {
    lines <- lines[-c(toc_start:toc_end)]
  }
  
  # Tìm các heading cấp 1–3
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
  
  # Tạo khối TOC: dòng "MỤC LỤC", dòng "[TOC]", và khối danh mục
  toc_full <- c(
    "MỤC LỤC",
    "[TOC]",
    "<!-- TOC start -->",
    headings$toc_line,
    "<!-- TOC end -->"
  )
  
  # Gộp toàn bộ lại
  new_lines <- c(toc_full, "", lines)
  
  # Ghi ra file
  write_lines(new_lines, file)
  cat("✅ Đã chèn TOC cho cả Typora và GitHub vào", file, "\n")
}

# 👉 Chạy hàm
update_typora_and_github_toc()
