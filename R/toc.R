suppressPackageStartupMessages({
  library(stringi)
  library(purrr)
})

# 👉 Hàm chuyển tiêu đề thành anchor theo chuẩn Pandoc/GitHub
make_anchor <- function(text) {
  text %>%
    stri_trans_general("Latin-ASCII") %>%    # bỏ dấu
    tolower() %>%
    gsub("[^a-z0-9\\s-]", "", .) %>%         # bỏ emoji/ký tự lạ
    gsub("\\s+", "-", .) %>%                # thay khoảng trắng = gạch ngang
    gsub("-+", "-", .) %>%                  # bỏ gạch thừa
    gsub("^-|-$", "", .)                    # bỏ đầu/cuối
}

# 👉 Tạo TOC từ file .md
create_toc_from_md <- function(file, max_level = 3) {
  lines <- readLines(file, warn = FALSE)
  
  lines %>%
    keep(~ grepl(paste0("^#{1,", max_level, "} "), .x)) %>%
    map_chr(function(line) {
      level <- attr(regexpr("^#+", line), "match.length")
      heading <- gsub("^#+\\s*", "", line)
      anchor <- make_anchor(heading)
      indent <- switch(as.character(level),
                       "1" = "- ",
                       "2" = "  - ",
                       "3" = "    - ",
                       "")
      sprintf("%s[%s](#%s)", indent, heading, anchor)
    }) %>%
    (\(toc) c("<!-- TOC start -->", toc, "<!-- TOC end -->"))()
}

# 👉 Cập nhật README.md
readme_file <- "README.md"
readme_lines <- readLines(readme_file, warn = FALSE)
toc_lines <- create_toc_from_md(readme_file)

toc_start <- grep("<!-- TOC start -->", readme_lines)
toc_end <- grep("<!-- TOC end -->", readme_lines)

new_readme <- if (length(toc_start) == 1 && length(toc_end) == 1 && toc_start < toc_end) {
  c(readme_lines[1:(toc_start - 1)], toc_lines, readme_lines[(toc_end + 1):length(readme_lines)])
} else {
  c(readme_lines[1], "", toc_lines, "", readme_lines[-1])
}

writeLines(new_readme, readme_file)
cat("✅ TOC đã được cập nhật trong README.md\n")
