suppressPackageStartupMessages({
  library(readr)
  library(stringr)
  library(dplyr)
  library(glue)
})

update_typora_and_github_toc <- function(file = "README.md") {
  # Đọc file
  lines <- read_lines(file)
  
  # Xoá TOC cũ: tiêu đề MỤC LỤC, [TOC], khối <!-- TOC start --> ... <!-- TOC end -->
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
  
  # Tạo khối TOC: "MỤC LỤC", "[TOC]", <!-- TOC -->
  toc_full <- c(
    "MỤC LỤC",
    "[TOC]",
    "<!-- TOC start -->",
    headings$toc_line,
    "<!-- TOC end -->"
  )
  
  # Thêm "go to MỤC LỤC" sau mỗi đoạn văn không phải heading, không phải danh sách
  lines_augmented <- c()
  for (i in seq_along(lines)) {
    lines_augmented <- c(lines_augmented, lines[i])
    
    # Điều kiện để là đoạn văn cần thêm dòng liên kết
    is_para <- nzchar(lines[i]) &&           # dòng không rỗng
      !str_detect(lines[i], "^\\s*[-*] ") && # không phải danh sách
      !str_detect(lines[i], "^#{1,6}\\s")    # không phải heading
    
    is_next_blank_or_end <- (i == length(lines)) || str_trim(lines[i + 1]) == ""
    
    if (is_para && is_next_blank_or_end) {
      lines_augmented <- c(lines_augmented, "*go to [MỤC LỤC](#mục-lục)*", "")
    }
  }
  
  # Gộp toàn bộ lại: TOC mới + nội dung đã thêm link
  new_lines <- c(toc_full, "", lines_augmented)
  
  # Ghi ra file
  write_lines(new_lines, file)
  cat("✅ Đã chèn TOC và link 'go to MỤC LỤC' sau mỗi đoạn văn.\n")
}

# 👉 Chạy hàm
update_typora_and_github_toc()
