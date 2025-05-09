# Dự án luận án: dtcs25_sstt

Đây là dự án Quarto dạng sách (`book`) được xây dựng cho luận án Y khoa của BS.CK2 Đỗ Thanh Liêm về sa sút trí tuệ.

## 📁 Cấu trúc thư mục

```
dtcs25_sstt/
├── _quarto.yml                  # Cấu hình dự án Quarto
├── index.qmd                    # Trang đầu
├── dat-van-de.qmd              # Đặt vấn đề (không đánh số)
├── 01-tong-quan-tai-lieu.qmd   # Chương 1: Tổng quan tài liệu
├── 02-doi-tuong-phuong-phap.qmd# Chương 2: Đối tượng và phương pháp
├── 03-ket-qua.qmd              # Chương 3: Kết quả
├── 04-ban-luan.qmd             # Chương 4: Bàn luận
├── ket-luan.qmd                # Kết luận
├── kien_nghi.qmd               # Kiến nghị
├── tai-lieu-tham-khao.qmd     # Tài liệu tham khảo
├── R/
│   └── packages.R              # Tải gói R cần thiết
└── source/
    ├── sstt_reference.bib      # File BibTeX chứa tài liệu tham khảo
    ├── ama-brackets.csl        # Style trích dẫn AMA
    └── sstt_dtcs_quato_words_input.docx # Mẫu Word định dạng sẵn
```

## 🚀 Hướng dẫn nhanh

- Để render: chạy `quarto render`
- Đảm bảo file Word mẫu và BibTeX tồn tại đúng đường dẫn
- Tùy chỉnh nội dung từng `.qmd` tương ứng với chương

---

🧠 *Dự án này giúp chuẩn hóa và tự động hóa quy trình viết luận án Y khoa bằng R và Quarto.*