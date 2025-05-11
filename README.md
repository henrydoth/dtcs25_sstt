# 🧠 Luận văn Y khoa – ĐÁNH GIÁ NHẬN THỨC VÀ SA SÚT TRÍ TUỆ (DTCS25_SSTT)

<!-- TOC start -->
- [🧠 Luận văn Y khoa – ĐÁNH GIÁ NHẬN THỨC VÀ SA SÚT TRÍ TUỆ (DTCS25_SSTT)](#-luan-van-y-khoa-danh-gia-nhan-thuc-va-sa-sut-tri-tue-dtcs25sstt)
  - [📘 Giới thiệu](#-gioi-thieu)
  - [📁 Cấu trúc thư mục](#-cau-truc-thu-muc)
- [10/5/2025](#1052025)
  - [📤 Kết quả đầu ra](#-ket-qua-dau-ra)
  - [📚 License](#-license)
- [Một số lệnh git](#mot-so-lenh-git)
    - [📘 **Các phím tắt cơ bản trong `nano` (hoặc `pico`)**](#-cac-phim-tat-co-ban-trong-nano-hoac-pico)
    - [✅ Hành động cần làm tiếp:](#-hanh-dong-can-lam-tiep)
  - [🚀 **Cheat Sheet Git + Terminal trên macOS**](#-cheat-sheet-git-terminal-tren-macos)
    - [📂 Di chuyển & quản lý thư mục](#-di-chuyen-quan-ly-thu-muc)
    - [🛠️ **Git cơ bản**](#-git-co-ban)
    - [🔁 **Lịch sử và chỉnh sửa dòng lệnh**](#-lich-su-va-chinh-sua-dong-lenh)
    - [📌 Mẹo thường dùng](#-meo-thuong-dung)
    - [quan trong để ADD TOC vô file này](#quan-trong-de-add-toc-vo-file-nay)
<!-- TOC end -->




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

## 📤 Kết quả đầu ra

> 📄 File Word được xuất bằng `officedown`, hỗ trợ `ggplot2`, `flextable`, `glue`, caption, TOC, và định dạng đúng chuẩn tiếng Việt.

---

## 📚 License

MIT © 2025 [BS.CK2 Đỗ Thanh Liêm](https://github.com/henrydoth)	

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

### ✅ Hành động cần làm tiếp:

Chạy dòng lệnh sau để **thêm tất cả các thay đổi (bao gồm file mới và file đã sửa):**

```
bash


CopyEdit
git add .
```

Rồi tiếp tục commit lại:

```
bash


CopyEdit
git commit -m "📝 Cập nhật toàn bộ thay đổi: README, hướng dẫn terminal, cấu trúc"
```

Cuối cùng, đẩy lên GitHub:

```
bash


CopyEdit
git push origin main
```

Bạn muốn mình viết file `docs_git/huong_dan_terminal.md` đầy đủ hướng dẫn Git bằng terminal không?



##### You said:

tổng hợp lại cheetsheet



###### ChatGPT said:

Dưới đây là **Tổng hợp Cheat Sheet Git + Terminal cơ bản trên Mac** – cực kỳ hữu ích cho bạn khi dùng Terminal để quản lý dự án Quarto trên GitHub:

------

## 🚀 **Cheat Sheet Git + Terminal trên macOS**

### 📂 Di chuyển & quản lý thư mục

| Hành động                | Lệnh                                           |
| ------------------------ | ---------------------------------------------- |
| Xem danh sách file       | `ls`                                           |
| Vào thư mục              | `cd ten_thu_muc`                               |
| Quay lại thư mục trước   | `cd ..`                                        |
| Tạo file mới             | `touch ten_file.md`                            |
| Mở file để chỉnh         | `nano ten_file.md`                             |
| Lưu & thoát trong `nano` | `Ctrl + O` (save), `Enter`, `Ctrl + X` (thoát) |



------

### 🛠️ **Git cơ bản**

| Hành động            | Lệnh                              |
| -------------------- | --------------------------------- |
| Kiểm tra trạng thái  | `git status`                      |
| Thêm tất cả thay đổi | `git add .`                       |
| Thêm file cụ thể     | `git add ten_file.md`             |
| Commit với mô tả     | `git commit -m "Tin nhắn commit"` |
| Đẩy lên GitHub       | `git push origin main`            |
| Lấy thay đổi mới     | `git pull`                        |



------

### 🔁 **Lịch sử và chỉnh sửa dòng lệnh**

| Hành động                   | Phím        |
| --------------------------- | ----------- |
| Lệnh trước đó               | `↑`         |
| Lệnh kế tiếp                | `↓`         |
| Di chuyển con trỏ trái/phải | `←` / `→`   |
| Về đầu dòng                 | `Ctrl + A`  |
| Về cuối dòng                | `Ctrl + E`  |
| Xoá một ký tự trái          | `Backspace` |
| Xoá từ con trỏ đến hết dòng | `Ctrl + K`  |



------

### 📌 Mẹo thường dùng

- Lỡ sai tên lệnh? Gõ `↑` để sửa lệnh cũ.
- Lỡ commit sai nội dung? Dùng `git commit --amend` (cẩn thận).
- Lỡ commit rồi quên `add` file? Dùng `git add . && git commit --amend --no-edit`.

### quan trong để ADD TOC vô file này
- Rscript R/toc.R
