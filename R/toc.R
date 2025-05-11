# 🎯 Script tạo TOC và chèn vào README.md

# Hàm tạo TOC từ các heading cấp 1–3
create_toc_from_readme <- function(file) {
  lines <- readLines(file, warn = FALSE)
  toc_lines <- c("<!-- TOC start -->")
  
  for (line in lines) {
    if (grepl("^#{1,3} ", line)) {
      level <- attr(regexpr("^#+", line), "match.length")
      heading_text <- gsub("^#+\\s+", "", line)
      
      # ⚠️ Sửa lỗi: không dùng pipe với dấu chấm `.`
      anchor <- tolower(heading_text)
      anchor <- gsub("[^a-z0-9\\s-]", "", anchor)
      anchor <- gsub("\\s+", "-", anchor)
      
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

# Đường dẫn đến README.md
readme_file <- "README.md"

# Tạo TOC
toc_lines <- create_toc_from_readme(readme_file)
readme_lines <- readLines(readme_file, warn = FALSE)

# Tìm đoạn TOC cũ
toc_start <- grep("<!-- TOC start -->", readme_lines)
toc_end <- grep("<!-- TOC end -->", readme_lines)

# Thay thế TOC cũ hoặc chèn TOC mới
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

# Ghi đè lại README.md
writeLines(new_readme, readme_file)
cat("✅ Đã cập nhật TOC vào README.md\n")
