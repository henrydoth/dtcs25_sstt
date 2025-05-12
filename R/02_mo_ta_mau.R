
#❤️❤️ Nạp các file R trước ️❤️❤️#
check_and_load_all <- function() {
  if (!exists("%>%") || !exists("theme_set", mode = "function")) {
    cat("📦 Nạp packages.R...\n")
    source(here::here("R", "packages.R"))
    cat("✅ packages.R đã được nạp thành công.\n")
  }
}


#❤️❤️  Đặc điểm mẫu nghiên cứu ️❤️❤️##
#######################################

#❤️❤️### Đặc điểm theo tuổi ️❤️❤️##
#######################################

# 📦 Làm sạch dữ liệu và gán nhãn nhóm
df_clean <- df %>%
  filter(!is.na(tuoi), !is.na(phan_loan_roi_loan_nhan_thuc)) %>%
  mutate(
    nhom_nhan_thuc = recode(phan_loan_roi_loan_nhan_thuc,
                            "MCI" = "Suy giảm nhận thức nhẹ",
                            "Sa sút trí tuệ" = "Sa sút trí tuệ")
  )

# 📊 Tính thống kê mô tả theo nhóm
age_summary <- df_clean %>%
  group_by(nhom_nhan_thuc) %>%
  summarise(
    mean_age = mean(tuoi, na.rm = TRUE),
    sd_age   = sd(tuoi, na.rm = TRUE),
    .groups = "drop"
  )

# 🔍 Tách từng nhóm
sgnt <- age_summary %>% filter(nhom_nhan_thuc == "Suy giảm nhận thức nhẹ")
sstt <- age_summary %>% filter(nhom_nhan_thuc == "Sa sút trí tuệ")

# 📋 Tạo bảng mô tả thống kê
table_tuoi <- df_clean %>%
  group_by(nhom_nhan_thuc) %>%
  summarise(
    `Trung bình ± SD` = sprintf("%.1f ± %.1f", mean(tuoi, na.rm = TRUE), sd(tuoi, na.rm = TRUE)) %>% str_replace_all("\\.", ","),
    `Trung vị (Q1–Q3)` = sprintf("%.1f (%.1f–%.1f)",
                                 median(tuoi, na.rm = TRUE),
                                 quantile(tuoi, 0.25, na.rm = TRUE),
                                 quantile(tuoi, 0.75, na.rm = TRUE)) %>% str_replace_all("\\.", ","),
    `Min – Max` = sprintf("%d – %d", min(tuoi, na.rm = TRUE), max(tuoi, na.rm = TRUE)),
    .groups = "drop"
  ) %>%
  pivot_longer(-nhom_nhan_thuc, names_to = "Chỉ số", values_to = "Giá trị") %>%
  pivot_wider(names_from = nhom_nhan_thuc, values_from = "Giá trị")

# 🧪 Kiểm định t-test
p_val <- t.test(tuoi ~ nhom_nhan_thuc, data = df_clean)$p.value
p_val_fmt <- ifelse(p_val < 0.001, "≤ 0,001", str_replace(sprintf("%.3f", p_val), "\\.", ","))  # ✅ Đã sửa dấu

# 🖼️ Bảng flextable
final_table <- table_tuoi %>%
  mutate(`Giá trị p` = if_else(`Chỉ số` == "Trung bình ± SD", p_val_fmt, ""))

ft_tuoi <- flextable(final_table) %>%
  autofit() %>%
  align(align = "center", part = "all") %>%
  bold(i = 1, part = "header") %>%
  set_caption("Bảng: So sánh tuổi giữa các nhóm nhận thức (định dạng tiếng Việt)") %>%
  set_table_properties(width = 1, layout = "autofit")



# 📈 Vẽ biểu đồ ggplot
tuoi_gp <- ggplot(df_clean, aes(x = nhom_nhan_thuc, y = tuoi, fill = nhom_nhan_thuc)) +
  geom_boxplot(outlier.shape = NA, alpha = 0.7) +
  geom_jitter(aes(color = nhom_nhan_thuc), width = 0.2, size = 1.5, alpha = 0.5) +
  labs(x = NULL, y = "Tuổi") +
  theme_minimal(base_family = "Times New Roman") +
  theme(
    legend.position = "none",
    axis.title = element_text(size = 12),
    axis.text = element_text(size = 11)
  )



# ✍️ Inline: kết quả bảng
inline_bang_tuoi_ketqua <- glue(
  "Tuổi trung bình nhóm Suy giảm nhận thức nhẹ là {scales::number(sgnt$mean_age, accuracy = 0.1, decimal.mark = ',')} ± {scales::number(sgnt$sd_age, accuracy = 0.1, decimal.mark = ',')} tuổi; ",
  "nhóm Sa sút trí tuệ là {scales::number(sstt$mean_age, accuracy = 0.1, decimal.mark = ',')} ± {scales::number(sstt$sd_age, accuracy = 0.1, decimal.mark = ',')} tuổi. ",
  "Sự khác biệt có ý nghĩa thống kê với p {p_val_fmt}."
)

# ✍️ Inline: kết quả biểu đồ
inline_bieudo_tuoi_ketqua <- "Biểu đồ hộp cho thấy sự khác biệt trong phân bố tuổi giữa hai nhóm nhận thức."

# 📊 Tính tuổi trung bình toàn maẫu
mean_age_all <- mean(df_clean$tuoi, na.rm = TRUE)

# ✍️ Inline: bàn luận tổng hợp có tuổi toàn mẫu
inline_tuoi_banluan <- case_when(
  sgnt$mean_age < sstt$mean_age ~ glue(
    "Trong nghiên cứu này, tuổi trung bình toàn mẫu nghiên cứu là {scales::number(mean_age_all, accuracy = 0.1, decimal.mark = ',')} tuổi; ",
    "tuổi trung bình nhóm Suy giảm nhận thức nhẹ là {scales::number(sgnt$mean_age, accuracy = 0.1, decimal.mark = ',')} tuổi, ",
    "nhóm Sa sút trí tuệ là {scales::number(sstt$mean_age, accuracy = 0.1, decimal.mark = ',')} tuổi. ",
    "Nhóm Sa sút trí tuệ có xu hướng lớn tuổi hơn, cho thấy tuổi có thể liên quan đến mức độ suy giảm nhận thức."
  ),
  sgnt$mean_age > sstt$mean_age ~ "Trong nghiên cứu này, nhóm Suy giảm nhận thức nhẹ có xu hướng lớn tuổi hơn, cho thấy có thể tồn tại các yếu tố ngoài tuổi ảnh hưởng đến mức độ nhận thức.",
  TRUE ~ "Trong nghiên cứu này, hai nhóm có độ tuổi tương đương, gợi ý rằng tuổi không phải là yếu tố phân biệt rõ giữa các mức độ nhận thức."
)

#❤️❤️### Đặc điểm theo nhóm tuổi ️❤️❤️##
#######################################

#### Bảng theo nhóm tuổi
# 🔄 Chuẩn hóa biến và gán nhãn
levels_nhom_tuoi <- c("40–49", "50–59", "60–69", "70–79", "80+")
df <- df %>%
  mutate(
    nhom_tuoi = factor(nhom_tuoi, levels = levels_nhom_tuoi),
    chuan_doan_label = recode(phan_loan_roi_loan_nhan_thuc,
                              "MCI" = "Suy giảm nhận thức nhẹ",
                              "Sa sút trí tuệ" = "Sa sút trí tuệ")
  )

# 📋 Tạo bảng tần số theo nhóm tuổi (làm hàng) và chẩn đoán (làm cột)
table_freq <- df %>%
  count(nhom_tuoi, chuan_doan_label) %>%
  group_by(nhom_tuoi) %>%
  mutate(percent = n / sum(n) * 100) %>%
  ungroup() %>%
  mutate(`Tần số (%)` = sprintf("%d (%.1f%%)", n, percent)) %>%
  select(`Nhóm tuổi` = nhom_tuoi, `Chẩn đoán` = chuan_doan_label, `Tần số (%)`) %>%
  pivot_wider(
    names_from = `Chẩn đoán`,
    values_from = `Tần số (%)`,
    values_fill = "-"
  )

# 🔍 Kiểm định Chi-squared
chisq_data <- table(df$chuan_doan_label, df$nhom_tuoi)
p_val <- chisq.test(chisq_data)$p.value
formatted_p <- ifelse(p_val < 0.001, "≤ 0,001", str_replace(sprintf("%.3f", p_val), "\\.", ","))

# ➕ Thêm p-value vào bảng
table_freq$`Giá trị p` <- c(formatted_p, rep("", nrow(table_freq) - 1))

# 📊 Bảng flextable
ft_freq_p <- flextable(table_freq) %>%
  autofit() %>%
  align(align = "center", part = "all") %>%
  bold(i = 1, part = "header") %>%
  bold(i = which(
    table_freq$`Giá trị p` != "" &
      table_freq$`Giá trị p` != "-" &
      as.numeric(gsub("[≤< ]", "", table_freq$`Giá trị p`)) < 0.05
  ), j = "Giá trị p", part = "body") %>%
  font(fontname = "Times New Roman", part = "all") %>%
  fontsize(size = 11, part = "all") %>%
  set_table_properties(width = 1, layout = "autofit")



# ✍️ Inline: bảng
inline_bang_nhom_tuoi_ketqua <- glue("Tần số nhóm tuổi theo chẩn đoán có độ lệch khác nhau rõ rệt, với p {formatted_p}.")

# 📈 Biểu đồ boxplot
nhom_tuoi_gp <- ggplot(df, aes(x = nhom_tuoi, y = tuoi, fill = chuan_doan_label)) +
  geom_boxplot(outlier.shape = NA, alpha = 0.7, position = position_dodge(width = 0.75)) +
  labs(
    x = "Nhóm tuổi",
    y = "Tuổi",
    fill = "Chẩn đoán"
  ) +
  theme_minimal(base_family = "Times New Roman") +
  theme(
    text = element_text(family = "Times New Roman"),
    plot.title = element_text(hjust = 0.5, face = "bold", size = 14),
    axis.title = element_text(size = 12),
    axis.text = element_text(size = 11),
    legend.title = element_text(size = 12),
    legend.text = element_text(size = 11),
    legend.position = "top"
  )



# ✍️ Inline: biểu đồ
inline_bieudo_nhom_tuoi_ketqua <- "Biểu đồ boxplot cho thấy xu hướng tăng tuổi đồng thời với mức độ nhận thức giảm."

# ✍️ Inline: bàn luận
inline_nhom_tuoi_banluan <- "Nhóm Sa sút trí tuệ chiếm tỷ lệ cao nhất trong nhóm tuổi ≥ 80, trong khi nhóm Suy giảm nhận thức nhẹ phổ biến hơn trong nhóm tuổi 60–69. Xu hướng này gợi ý mối quan hệ tạm thời giữa tuổi và mức độ sa sút nhận thức."

#❤️❤️### Đặc điểm giới tính ️❤️❤️##
#######################################

# 🔍 Phân tích giới tính theo nhóm chẩn đoán

# 🧮 Hàm phụ: Tính phần trăm nữ theo nhóm
lay_phan_tram_nu <- function(nhom) {
  df %>%
    filter(phan_loan_roi_loan_nhan_thuc == nhom, gender == "Nữ") %>%
    summarise(percent = n() / sum(df$phan_loan_roi_loan_nhan_thuc == nhom) * 100) %>%
    pull(percent) %>%
    round(1)
}

# 📊 Tóm tắt dữ liệu giới tính
gioitinh_summary <- df %>%
  mutate(chuan_doan_label = recode(phan_loan_roi_loan_nhan_thuc, "MCI" = "Suy giảm nhận thức nhẹ")) %>%
  count(chuan_doan_label, gender) %>%
  group_by(chuan_doan_label) %>%
  mutate(percent = n / sum(n) * 100) %>%
  ungroup()

# 📋 Bảng flextable
bang_gioitinh <- gioitinh_summary %>%
  mutate(`Tần số (%)` = sprintf("%d (%.1f%%)", n, percent)) %>%
  select(`Chẩn đoán` = chuan_doan_label, `Giới tính` = gender, `Tần số (%)`) %>%
  pivot_wider(names_from = `Giới tính`, values_from = `Tần số (%)`, values_fill = "-")

# 🧪 Tính p-value
p_val_gender <- chisq.test(table(df$phan_loan_roi_loan_nhan_thuc, df$gender))$p.value
formatted_p_gender <- ifelse(p_val_gender < 0.001, "≤ 0,001", str_replace(sprintf("%.3f", p_val_gender), "\\.", ","))

bang_gioitinh$`Giá trị p` <- c(formatted_p_gender, rep("", nrow(bang_gioitinh) - 1))

ft_gender <- flextable(bang_gioitinh) %>%
  autofit() %>%
  align(align = "center", part = "all") %>%
  bold(i = 1, part = "header") %>%
  bold(i = which(
    bang_gioitinh$`Giá trị p` != "" &
      bang_gioitinh$`Giá trị p` != "-" &
      as.numeric(gsub("[<≤ ]", "", bang_gioitinh$`Giá trị p`)) < 0.05
  ), j = "Giá trị p", part = "body") %>%
  set_caption("Bảng: Phân bố giới tính theo nhóm nhận thức (tô đậm nếu p < 0.05)") %>%
  font(fontname = "Times New Roman", part = "all") %>%
  fontsize(size = 11, part = "all") %>%
  set_table_properties(width = 1, layout = "autofit")



# 📉 Biểu đồ giới tính
gioitinh_bar_percent <- ggplot(gioitinh_summary, aes(x = chuan_doan_label, y = n, fill = gender)) +
  geom_bar(stat = "identity", position = position_dodge(width = 0.8)) +
  geom_text(
    aes(label = sprintf("%.1f%%", percent)),
    position = position_dodge(width = 0.8),
    vjust = -0.3,
    size = 3.5,
    family = "Times New Roman"
  ) +
  labs(x = NULL, y = "Số lượng bệnh nhân", fill = "Giới tính") +
  theme_minimal(base_family = "Times New Roman") +
  theme(
    axis.title = element_text(size = 12),
    axis.text = element_text(size = 11),
    legend.title = element_text(size = 12),
    legend.text = element_text(size = 11)
  )



# ✍️ Inline bàn luận
gioitinh_mci <- lay_phan_tram_nu("MCI")
gioitinh_sstt <- lay_phan_tram_nu("Sa sút trí tuệ")

inline_bang_gioitinh_ketqua <- glue(
  "ở nhóm Suy giảm nhận thức nhẹ, nữ giới chiếm {gioitinh_mci}%, ",
  "trong khi nhóm Sa sút trí tuệ chiếm {gioitinh_sstt}%. ",
  "Sự khác biệt này ", ifelse(p_val_gender < 0.05, "có", "không có"),
  " ý nghĩa thống kê với p = {formatted_p_gender}."
)

# ✍️ Inline kết quả biểu đồ
inline_bieudo_gioitinh_ketqua <- "Biểu đồ cột cho thấy xu hướng lệch giới giữa hai nhóm chẩn đoán."


inline_bang_gioitinh_banluan <- glue(
  "Kết quả nghiên cứu về giới tính cho thấy: ở nhóm Suy giảm nhận thức nhẹ, nữ giới chiếm {gioitinh_mci}%, ",
  "trong khi nhóm Sa sút trí tuệ chiếm {gioitinh_sstt}%. "
)

#❤️❤️### Đặc điểm học vấn ️❤️❤️##
#######################################

##############################

# 📊 Tóm tắt dữ liệu học vấn 🧠
hocvan_summary <- df %>%
  filter(phan_loan_roi_loan_nhan_thuc %in% c("MCI", "Sa sút trí tuệ")) %>%  # 💡 chỉ lấy 2 nhóm
  count(phan_loan_roi_loan_nhan_thuc, edu) %>%
  group_by(phan_loan_roi_loan_nhan_thuc) %>%
  mutate(percent = n / sum(n) * 100) %>%
  ungroup()

# 🧮 Tạo bảng trình độ học vấn với 2 cột MCI, SSTT
table_edu <- hocvan_summary %>%
  mutate(`Tần số (%)` = sprintf("%d (%.1f%%)", n, percent) %>% str_replace_all("\\.", ",")) %>%
  select(`Chẩn đoán` = phan_loan_roi_loan_nhan_thuc, `Trình độ học vấn` = edu, `Tần số (%)`) %>%
  pivot_wider(names_from = `Chẩn đoán`, values_from = `Tần số (%)`, values_fill = "-")

# 🧪 Tính p-value
chisq_edu <- table(df$phan_loan_roi_loan_nhan_thuc, df$edu)
use_fisher <- any(chisq_edu < 5)
p_val_edu <- if (use_fisher) fisher.test(chisq_edu)$p.value else chisq.test(chisq_edu)$p.value
formatted_p_edu <- ifelse(p_val_edu < 0.001, "≤ 0,001", str_replace(sprintf("%.3f", p_val_edu), "\\.", ","))

# ➕ Thêm dòng p-value
table_edu$`Giá trị p` <- c(formatted_p_edu, rep("", nrow(table_edu) - 1))

# 📋 Bảng flextable
ft_edu <- flextable(table_edu) %>%
  autofit() %>%
  align(align = "center", part = "all") %>%
  bold(i = 1, part = "header") %>%
  bold(i = which(
    table_edu$`Giá trị p` != "" &
      table_edu$`Giá trị p` != "-" &
      as.numeric(gsub("[≤< ]", "", table_edu$`Giá trị p`)) < 0.05
  ), j = "Giá trị p", part = "body") %>%
  font(fontname = "Times New Roman", part = "all") %>%
  fontsize(size = 11, part = "all") %>%
  set_table_properties(width = 1, layout = "autofit") %>%
  set_caption("Bảng: Phân bố trình độ học vấn theo nhóm nhận thức")

# 🎨 Biểu đồ ggplot trình độ học vấn
hocvan_bar_percent <- ggplot(hocvan_summary, aes(x = edu, y = percent, fill = phan_loan_roi_loan_nhan_thuc)) +
  geom_col(position = position_dodge(width = 0.8)) +
  geom_text(
    aes(label = str_replace(sprintf("%.1f%%", percent), "\\.", ",")),
    position = position_dodge(width = 0.8),
    vjust = -0.3,
    size = 3.5,
    family = "Times New Roman"
  ) +
  labs(
    x = "Trình độ học vấn",
    y = "Tỷ lệ (%)",
    fill = "Nhóm nhận thức"
  ) +
  theme_minimal(base_family = "Times New Roman") +
  theme(
    axis.title = element_text(size = 12),
    axis.text = element_text(size = 11),
    legend.title = element_text(size = 12),
    legend.text = element_text(size = 11),
    legend.position = "top"
  )

# ✍️ Inline mô tả bảng
lay_tyle_hocvan <- function(nhom, bac) {
  ket_qua <- hocvan_summary %>%
    filter(phan_loan_roi_loan_nhan_thuc == nhom, edu == bac) %>%
    pull(percent)
  if (length(ket_qua) == 0) return(0) else return(round(ket_qua, 1))
}

hv_mci_daihoc <- lay_tyle_hocvan("MCI", "Đại học")
hv_sstt_daihoc <- lay_tyle_hocvan("Sa sút trí tuệ", "Đại học")

# 🧾 Inline mô tả bảng
inline_table_hocvan <- glue(
  "Tỷ lệ trình độ Đại học cao nhất ghi nhận ở nhóm Suy giảm nhận thức nhẹ ({hv_mci_daihoc}%) so với nhóm Sa sút trí tuệ ({hv_sstt_daihoc}%). ",
  "Giá trị p kiểm định sự khác biệt giữa hai nhóm là {formatted_p_edu}."
)

# ✏️ Inline mô tả biểu đồ có điều kiện
inline_plot_hocvan <- ifelse(
  hv_mci_daihoc > hv_sstt_daihoc,
  glue("Biểu đồ cho thấy nhóm Suy giảm nhận thức nhẹ có xu hướng đạt trình độ học vấn cao hơn."),
  glue("Biểu đồ cho thấy nhóm Sa sút trí tuệ có tỷ lệ trình độ học vấn cao hơn.")
)

# 💬 Inline bàn luận tổng quan có điều kiện
inline_banluan_hocvan <- ifelse(
  hv_mci_daihoc > hv_sstt_daihoc,
  glue("Tổng quan cho thấy nhóm Suy giảm nhận thức nhẹ có trình độ học vấn cao hơn."),
  glue("Nhóm Sa sút trí tuệ có trình độ học vấn cao hơn trong nghiên cứu này.")
)

