suppressPackageStartupMessages({
  library(readr)
  library(stringr)
  library(dplyr)
  library(glue)
})

update_typora_and_github_toc <- function(file = "README.md") {
  # 1. Đọc file gốc
  lines <- read_lines(file)
  
  # 2. Xoá các dòng tiêu đề MỤC LỤC, [TOC], và khối TOC cũ
  lines <- lines[!str_detect(lines, "^\\s*#{0,6}\\s*MỤC LỤC\\s*$") & trimws(lines) != "[TOC]"]
  toc_start <- which(str_detect(lines, "<!-- TOC start -->"))
  toc_end   <- which(str_detect(lines, "<!-- TOC end -->"))
  if (length(toc_start) > 0 && length(toc_end) > 0 && toc_end >= toc_start) {
    lines <- lines[-c(toc_start:toc_end)]
  }
  
  # 3. Tìm các heading cấp 1–3 để làm TOC
  headings <- tibble(
    line = lines,
    linenum = seq_along(lines)
  ) %>%
    filter(str_detect(line, "^\\s*#{1,3} ")) %>%
    mutate(
      clean_line = str_trim(line),
      level = str_count(str_extract(clean_line, "^#+")),
      title = str_trim(str_remove(clean_line, "^#{1,3}\\s+")),
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
  
  # 4. Khối TOC gồm cả cho Typora và GitHub
  toc_full <- c(
    "MỤC LỤC",
    "[TOC]",
    "<!-- TOC start -->",
    headings$toc_line,
    "<!-- TOC end -->"
  )
  
  # 5. Chèn TOC + dòng trắng
  full_lines <- c(toc_full, "", lines)
  
  # 6. Thêm 2 dấu cách cho xuống dòng mềm trong GitHub (nếu không phải tiêu đề hoặc dòng trắng)
  full_lines <- sapply(full_lines, function(line) {
    if (grepl("^\\s*$", line) || grepl("^\\s*#{1,6}\\s", line)) {
      line
    } else {
      paste0(line, "  ")
    }
  })
  
  # 7. Ghi ra file
  write_lines(full_lines, file)
  cat("✅ Đã cập nhật TOC cho Typora và GitHub:", file, "\n")
}

# 👉 Thực thi
update_typora_and_github_toc()
