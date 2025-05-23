# 📚 CHEAT SHEET – CÁC HÀM R THƯỜNG DÙNG TRONG LUẬN VĂN BS. LOAN

## 📦 GÓI VÀ THIẾT LẬP

### pacman::p_load(...)
# Tải nhanh nhiều package R cùng lúc, tự động cài nếu thiếu.

### here::here(...)
# Tạo đường dẫn an toàn, không phụ thuộc hệ điều hành.

### glue(...)
# Ghép chuỗi với nội suy biến, ví dụ: glue("Tuổi = {tuoi}").

### options(OutDec = ",")
# Dùng dấu phẩy cho số thập phân (kiểu Việt Nam).

---

## 📄 ĐỌC & XỬ LÝ DỮ LIỆU

### read_sav()
# Đọc dữ liệu từ file SPSS (.sav).

### read_csv() / write_csv()
# Đọc và ghi dữ liệu CSV.

### mutate()
# Tạo hoặc sửa cột dữ liệu.

### case_when()
# Gán giá trị theo điều kiện (tương đương ifelse nâng cao).

### factor(levels, labels)
# Tạo biến phân loại có nhãn rõ ràng.

### select(), filter()
# Chọn cột hoặc lọc dòng theo điều kiện.

### rowSums()
# Tính tổng nhiều cột (ví dụ tổng điểm NPI-Q).

### count()
# Đếm số lượng theo nhóm.

---

## 📊 THỐNG KÊ MÔ TẢ

### mean(), sd(), median()
# Trung bình, độ lệch chuẩn, trung vị.

### min(), max()
# Giá trị nhỏ nhất / lớn nhất.

### quantile(..., probs)
# Tính phân vị (ví dụ: Q1, Q3).

### round(x, 1)
# Làm tròn đến 1 chữ số thập phân.

---

## 📈 VẼ BIỂU ĐỒ VỚI ggplot2

### ggplot(df, aes(...)) + geom_*
# Tạo biểu đồ khung (boxplot, bar, histogram...).

### geom_boxplot(), geom_col(), geom_bar()
# Biểu đồ hộp, biểu đồ cột trị số hoặc tần suất.

### geom_text()
# Thêm nhãn lên biểu đồ.

### theme_minimal() + theme(...)
# Giao diện biểu đồ tối giản, có chỉnh font / size chữ.

### labs(x, y), ylim()
# Gắn nhãn trục và giới hạn trục tung.

---

## 📋 TẠO BẢNG ĐẸP VỚI FLEXTABLE

### flextable(df)
# Tạo bảng chuẩn đẹp cho Word.

### autofit()
# Tự động điều chỉnh độ rộng cột.

### set_caption("...")
# Gắn tiêu đề cho bảng.

### merge_v(), valign()
# Gộp ô theo cột và căn chỉnh theo chiều dọc.

### set_table_properties(width = 1)
# Bảng rộng full trang Word.

### colformat_num(decimal.mark = ",")
# Hiển thị số theo kiểu Việt (dấu phẩy thập phân).

### align(), bold(), fontsize(), font()
# Căn lề, in đậm, chỉnh cỡ chữ, chọn font.

---

## 🔧 HÀM TÙY BIẾN THƯỜNG DÙNG

### ft_vn(df)
# Tạo flextable định dạng tiếng Việt sẵn (số, font, NA).

### text_blue("abc")
# Tô màu xanh cho chữ inline trong Word.

### glue_collapse(c(...))
# Nối nhiều câu thành 1 đoạn văn dài.

---

## 🎯 GỢI Ý SỬ DỤNG
- Đặt `set_flextable_defaults()` và `theme_set()` ngay sau `pacman::p_load()` để đồng bộ format toàn dự án.
- Dùng `glue()` để tạo nhận xét tự động bằng tiếng Việt.
- Gộp các bảng `flextable` bằng `bind_rows()` và `merge_v()` nếu cần báo cáo dạng tổng hợp.

