library(here)
library(fs)

fs::dir_create(here("output"))
fs::dir_create(here("source"))
fs::dir_create(here("image", "pdf"))
fs::dir_create(here("others"))

message("✅ Đã tạo hoặc xác nhận các thư mục: output/, source/, image/pdf/, others/")