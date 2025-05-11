strip_accents <- function(text) {
  iconv(text, from = "UTF-8", to = "ASCII//TRANSLIT")
}

slugify <- function(text) {
  text <- strip_accents(text)
  text <- tolower(text)
  text <- gsub(":[^:]*:", "", text)
  text <- gsub("[^a-z0-9\\s-]", "", text)
  text <- gsub("\\s+", "-", text)
  return(text)
}

create_toc_from_readme <- function(file) {
  lines <- readLines(file, warn = FALSE)
  toc_lines <- c("<!-- TOC start -->")
  
  for (line in lines) {
    if (grepl("^#{1,3} ", line)) {
      level <- attr(regexpr("^#+", line), "match.length")
      heading_text <- gsub("^#+\\s+", "", line)
      anchor <- slugify(heading_text)
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

# Đường dẫn file README
readme_file <- "README.md"

# Đọc và cập nhật TOC
toc_lines <- create_toc_from_readme(readme_file)
readme_lines <- readLines(readme_file, warn = FALSE)

toc_start <- grep("<!-- TOC start -->", readme_lines)
toc_end <- grep("<!-- TOC end -->", readme_lines)

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

writeLines(new_readme, readme_file)
cat("✅ TOC đã được cập nhật trong README.md, chuẩn GitHub ✅\n")
