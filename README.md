# 🧠 Luận văn Y khoa – ĐÁNH GIÁ NHẬN THỨC VÀ SA SÚT TRÍ TUỆ (DTCS25_SSTT)

**Tác giả:** BS.CK2 Đỗ Thanh Liêm  
**Cơ sở:** Khoa Y học cổ truyền – Bệnh viện 30-4  
**Phần mềm:** Quản lý bằng [Quarto](https://quarto.org), [R](https://www.r-project.org), và [officedown](https://davidgohel.github.io/officedown/)

---

## 📘 Giới thiệu

Luận văn phân tích dữ liệu về **suy giảm nhận thức và sa sút trí tuệ**, sử dụng bộ công cụ **VnCA** và thang điểm **MMSE**. Mục tiêu gồm:

- Phân tích đặc điểm dân số học và nhận thức của người bệnh
- Tìm hiểu **mối tương quan giữa MMSE và các test nhận thức**
- Đánh giá **hiệu quả ứng dụng lâm sàng** của bộ test tại Bệnh viện 30-4

---

## 📁 Cấu trúc thư mục

```text
📁 dtcs25_sstt/
├── _quarto.yml                         # Cấu hình xuất bản
├── index.qmd                           # Trang bìa, giới thiệu
├── dat-van-de.qmd                      # Mở đầu
├── 01-tong-quan-tai-lieu.qmd           # Tổng quan tài liệu
├── 02-doi-tuong-phuong-phap.qmd        # Phương pháp
├── 03-ket-qua.qmd                      # Kết quả (✔ đã hoàn tất)
├── 04-ban-luan.qmd                     # Bàn luận (🛠 đang viết)
├── ket-luan.qmd                        # Kết luận
├── kien_nghi.qmd                       # Kiến nghị
├── tai-lieu-tham-khao.qmd             # Tài liệu tham khảo
├── R/
│   ├── packages.R                      # Nạp thư viện
│   └── load_data.R                     # Xử lý dữ liệu
├── source/
│   ├── sstt_dtcs_quato_words_input.docx  # Mẫu định dạng Word
│   ├── sstt_reference.bib              # File BibTeX
│   └── ama-brackets.csl                # Chuẩn AMA11
├── image/                              # Hình minh hoạ, biểu đồ
├── output/                             # File Word xuất bản


# 10/5/2025
- Thậy tuyệt có thể sử dụng cùng dự án trên mac và windows mà không cần dùng google drvie sync.

Sau khi cấu hình git git config --global --list

Git giờ đã biết tôi là henrydo, và GitHub sẽ tự động gắn commit của tôi vào tài khoản đúng, hiển thị ảnh đại diện, tên đầy đủ như trên GitHub Web. (Hy vọng push thử)
henrydoth chứ không phải henrydo

```

# Một số lệnh git



| Mục đích         | Lệnh terminal                        |
| ---------------- | ------------------------------------ |
| Tạo file md mới. | touch docs_git/huong_dan_terminal.md |
|                  | nano docs_git/huong_dan_terminal.md  |
|                  |                                      |

📦 Phím tắt điều hướng trong nano

| Mục tiêu di chuyển                | Phím tắt               |
| --------------------------------- | ---------------------- |
| 👉 Di chuyển **1 ký tự sang phải** | → (phím mũi tên phải)  |
| 👈 Di chuyển **1 ký tự sang trái** | ← (phím mũi tên trái)  |
| ⬇️ Xuống **dòng kế tiếp**          | ↓ (phím mũi tên xuống) |
| ⬆️ Lên **dòng phía trên**          | ↑ (phím mũi tên lên)   |
| 🔚 Tới **cuối dòng**               | `Ctrl + E`             |
| 🔙 Về **đầu dòng**                 | `Ctrl + A`             |
| ⬇️ Tới **dòng cuối cùng**          | `Ctrl + V` (page down) |
| ⬆️ Tới **dòng đầu tiên**           | `Ctrl + Y` (page up)   |
| 🔍 **Tìm kiếm** từ/ký tự           | `Ctrl + W`             |

​	

### 📘 **Các phím tắt cơ bản trong `nano` (hoặc `pico`)**

| Chức năng                     | Phím tắt                   | Ghi chú nhanh                             |
| ----------------------------- | -------------------------- | ----------------------------------------- |
| 📥 **Lưu file**                | `Ctrl + O`                 | (O = Output) → Nhấn Enter để xác nhận tên |
| 🚪 **Thoát nano/pico**         | `Ctrl + X`                 | Thoát, sẽ hỏi lưu nếu có thay đổi         |
| 🔍 **Tìm kiếm**                | `Ctrl + W`                 | (Where is...)                             |
| 🔁 **Tìm tiếp (Repeat)**       | `Ctrl + W`, rồi `Ctrl + W` | Tìm lặp tiếp cùng từ                      |
| ↩️ **Bắt đầu dòng**            | `Ctrl + A`                 | (A = Beginning of line)                   |
| ↘️ **Kết thúc dòng**           | `Ctrl + E`                 | (E = End of line)                         |
| ⬇️ **Xuống trang (Page Down)** | `Ctrl + V`                 | (V = View next page)                      |
| ⬆️ **Lên trang (Page Up)**     | `Ctrl + Y`                 | (Y = Previous page)                       |
| 🔡 **Xóa ký tự bên phải**      | `Ctrl + D`                 | Delete ký tự sau con trỏ                  |
| ⬅️ **Xóa dòng (Cut)**          | `Ctrl + K`                 | Cut (xóa và copy dòng)                    |
| 🧷 **Dán dòng đã cut**         | `Ctrl + U`                 | (U = Uncut)                               |
