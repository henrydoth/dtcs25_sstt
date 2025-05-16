# 🧠 Tự động mở các file khi mở project
files_to_open <- c(
  "sstt_reference.bib",
  "README.md",
  "dtt_quarto_output.qmd",
  "01-tong-quan-tai-lieu.qmd"
)

for (f in files_to_open) {
  if (file.exists(f)) {
    tryCatch(file.edit(f), error = function(e) message("❗Không mở được: ", f))
  } else {
    message("⚠️ File không tồn tại: ", f)
  }
}
