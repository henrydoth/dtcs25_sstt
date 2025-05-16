#Thêm toc vào file README.md
# run_all.R — Chạy từng bước trong pipeline phân tích 📊

source(here::here("R", "packages.R"))
message("✅ Đã nạp packages!")

source(here::here("R", "00_setup.R"))
message("🛠️ Đã thiết lập thông số mặc định!")

if (askYesNo("👉 Chạy bước 1: Load & xử lý dữ liệu?")) {
  source(here::here("R", "01_load_clean_data.R"))
  message("📂 Dữ liệu đã được nạp và làm sạch!")
}

if (askYesNo("👉 Chạy bước 2: Mô tả mẫu nghiên cứu?")) {
  source(here::here("R", "02_mo_ta_mau.R"))
  message("👥 Đã mô tả đặc điểm mẫu!")
}

if (askYesNo("👉 Chạy bước 3: Phân tích MMSE?")) {
  source(here::here("R", "03_mmse.R"))
  message("🧠 Đã phân tích MMSE!")
}

if (askYesNo("👉 Chạy bước 4: Phân tích các test nhận thức?")) {
  source(here::here("R", "04_tests.R"))
  message("🧪 Đã phân tích các test nhận thức!")
}

if (askYesNo("👉 Chạy bước 5: Tính tương quan MMSE và test?")) {
  source(here::here("R", "05_tuong_quan.R"))
  message("📈 Đã tính tương quan MMSE với các test!")
}

if (askYesNo("👉 Chạy bước 6: Phân tích mức độ hoàn thành test?")) {
  source(here::here("R", "06_hoan_thanh_test.R"))
  message("✅ Đã phân tích mức độ hoàn thành test!")
}

if (askYesNo("👉 Chạy bước 7: So sánh MMSE và phân loại lâm sàng?")) {
  source(here::here("R", "07_mmse_vs_lamsang.R"))
  message("🔍 Đã phân tích mối liên quan MMSE với chẩn đoán lâm sàng!")
}

message("🎉 Toàn bộ script đã chạy xong (hoặc theo lựa chọn của bạn)!")
