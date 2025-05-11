# 🎯 Tạo TOC và chèn vào README.md, chuẩn link GitHub

# Hàm chuyển tiêu đề sang anchor kiểu GitHub
make_github_anchor <- function(text) {
  text <- gsub(":[^:]*:", "", text) # loại bỏ emoji nếu dùng dạng :emoji:
  text <- iconv(text, from = "UTF-8", to = "ASCII//TRANSLIT") # bỏ dấu tiếng Việt
  text <- gsub("[^A-Za-z0-9 -]", "", text) # bỏ ký tự đặc biệt
  text <- tolower(text)
  text <- gsub("[[:space:]]+", "-", text) # khoảng trắng -> -
  text <- gsub("^-|-$", "", text) # xóa dấu - đầu/cuối
  return(text)
}

# Hàm tạo TOC từ heading cấp 1–3
create_toc_from_readme <- function(file) {
  lines <- readLines(file, warn = FALSE)
  toc_lines <- c("<!-- TOC start -->")
  
  for (line in lines) {
    if (grepl("^#{1,3} ", line)) {
      level <- attr(regexpr("^#+", line), "match.length")
      heading_text <- gsub("^#+\\s+", "", line)
      anchor <- make_github_anchor(heading_text)
      indent <- switch(
        as.character(level),
        "1" = "- ",
        "2" = "  - ",
        "3" = "    - ",
        ""
      )
      toc_line <- sprintf("%s[%s](#%s)", indent, heading_text, anchor)
      toc_lines <- c(toc_lines, toc_line)
    }
  }
  
  toc_lines <- c(toc_lines, "<!-- TOC end -->")
  return(toc_lines)
}

# Đường dẫn
readme_file <- "README.md"
toc_lines <- create_toc_from_readme(readme_file)
readme_lines <- readLines(readme_file, warn = FALSE)

# Tìm vị trí TOC cũ
toc_start <- grep("<!-- TOC start -->", readme_lines)
toc_end <- grep("<!-- TOC end -->", readme_lines)

# Thay hoặc chèn TOC
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

# Ghi lại file
writeLines(new_readme, readme_file)
cat("✅ TOC đã được cập nhật trong README.md, chuẩn GitHub ✅\n")
