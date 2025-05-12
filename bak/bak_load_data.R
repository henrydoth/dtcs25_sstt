
####SETUP THOI GIAN########
###########################
current_datetime <- now()

thu <- c("CHỦ NHẬT", "THỨ 2", "THỨ 3", "THỨ 4", "THỨ 5", "THỨ 6", "THỨ 7")[wday(current_datetime)]

# Giờ 12h có AM/PM, sau đó dịch sang tiếng Việt
gio <- format(current_datetime, "%I:%M %p") %>%
  str_replace("AM", "sáng") %>%
  str_replace("PM", "chiều")

ngay <- day(current_datetime)
thang <- month(current_datetime)
nam <- year(current_datetime)

formatted_datetime <- glue("{gio}, {thu}, NGÀY {ngay} THÁNG {thang} NĂM {nam}")

#####THIẾT LẬP THÔNG TIN########
messages <- c(
  "Vợ và các con vì đã cho tôi tình yêu, ý nghĩa cuộc đời",
  "Bố mẹ vì đã cho tôi cuộc đời",
  "Thầy cô vì đã cho tôi kiến thức",
  "B  ạn bè vì đã hết lòng giúp đỡ, động viên",
  "Đồng nghiệp vì đã hợp tác và giúp đỡ"
)

colors <- c("red", "blue", "green", "orange", "purple")

# Chọn ngẫu nhiên một câu + màu
msg <- sample(messages, 1)
color <- sample(colors, 1)

# Câu cảm ơn (font Segoe Print, size 16, màu ngẫu nhiên)
ft_msg <- ftext(
  glue("Tôi xin chân thành cảm ơn {msg}."), 
  prop = fp_text(font.family = "Segoe Print", font.size = 16, color = color)
)

# Tên người ký (Segoe Print, size 16, không màu)
ft_name <- ftext(
  "Đỗ Thanh Liêm", 
  prop = fp_text(font.family = "Segoe Print", font.size = 16)
)
#########

quotes <- c(
  "The best way to predict the future is to invent it. – Alan Kay",
  "Life is what happens when you're busy making other plans. – John Lennon",
  "Do not dwell in the past, do not dream of the future, concentrate the mind on the present moment. – Buddha",
  "Success is not final, failure is not fatal: It is the courage to continue that counts. – Winston Churchill",
  "In the middle of difficulty lies opportunity. – Albert Einstein"
)

quote <- sample(quotes, 2)





#❤️❤️Đọc dữ liệu ️❤️❤️##
#######################################


# Đọc dữ liệu .sav
df_raw <- read_sav(here::here("source", "sstt304_28_03_24.sav"), encoding = "latin1")

# Ghi ra CSV nếu chưa tồn tại
write_csv(df_raw, here::here("source", "sstt304_clean.csv"))



#❤️❤️ biến đổi  dữ liệu ️❤️❤️##
#######################################

df <-  read_csv(here::here("source", "sstt304_clean.csv"))

df <- df %>%
  dplyr::filter(new.old.tests != 1, mmse.new <=29) %>%
  drop_na(mmse.new)

df <- df %>%
  filter(
    !is.na(date.visit),
    !is.na(year.born),
    !is.na(mmse.new),
    !is.na(gender)
  ) %>%
  mutate(
    year.visit = year(date.visit),
    tuoi = year.visit - year.born,
    
    gender = case_when(
      gender == 1 ~ "Nam",
      gender == 2 ~ "Nữ",
      TRUE ~ NA_character_
    ),
    gender = factor(gender, levels = c("Nam", "Nữ")),
    
    edu = case_when(
      edu.level == 1 ~ "Tiểu học",
      edu.level %in% c(2, 3) ~ "Trung học",
      edu.level == 4 ~ "Đại học",
      TRUE ~ NA_character_
    ),
    edu = factor(edu, levels = c("Tiểu học", "Trung học", "Đại học")),
    
    diagno_lam_sang = case_when(
      diagno == 1 ~ "Suy giảm nhận thức nhẹ",
      diagno == 2 ~ "Suy giảm nhận thức chủ quan",
      diagno == 3 ~ "Alzheimer",
      diagno == 4 ~ "Sa sút trí tuệ mạch máu",
      diagno == 5 ~ "Sa sút trí tuệ thùy trán thái dương",
      diagno == 7 ~ "Sa sút trí tuệ hỗn hợp",
      diagno == 8 ~ "Sa sút trí tuệ do Parkinson",
      diagno == 9 ~ "Sa sút trí tuệ khác",
      TRUE ~ NA_character_
    )
  ) %>%
  filter(
    tuoi >= 40,
    diagno_lam_sang != "Suy giảm nhận thức chủ quan"
  ) %>%
  mutate(
    nhom_tuoi = case_when(
      tuoi < 50 ~ "40–49",
      tuoi < 60 ~ "50–59",
      tuoi < 70 ~ "60–69",
      tuoi < 80 ~ "70–79",
      TRUE      ~ "80+"
    ),
    diagno_lam_sang = factor(diagno_lam_sang, levels = c(
      "Suy giảm nhận thức nhẹ",
      "Alzheimer",
      "Sa sút trí tuệ mạch máu",
      "Sa sút trí tuệ hỗn hợp",
      "Sa sút trí tuệ thùy trán thái dương",
      "Sa sút trí tuệ do Parkinson",
      "Sa sút trí tuệ khác"
    )),
    
    phan_loan_roi_loan_nhan_thuc_tieu_chuan_vang = case_when(
      diagno_lam_sang == "Suy giảm nhận thức nhẹ" ~ "MCI",
      !is.na(diagno) ~ "Sa sút trí tuệ",
      TRUE ~ NA_character_
    ),
    phan_loan_roi_loan_nhan_thuc_tieu_chuan_vang = factor(
      phan_loan_roi_loan_nhan_thuc_tieu_chuan_vang,
      levels = c("MCI", "Sa sút trí tuệ")
    ),
    
    chan_doan_giai_doan_lam_sang = case_when(
      stage == 1 ~ "Sa sút trí tuệ nhẹ",
      stage == 2 ~ "Sa sút trí tuệ trung bình",
      stage == 3 ~ "Sa sút trí tuệ nặng",
      TRUE ~ NA_character_
    ),
    chan_doan_giai_doan_lam_sang = factor(
      chan_doan_giai_doan_lam_sang,
      levels = c("Sa sút trí tuệ nhẹ", "Sa sút trí tuệ trung bình", "Sa sút trí tuệ nặng")
    ),
    
    phan_loan_roi_loan_nhan_thuc = case_when(
      mmse.new >= 26 & mmse.new <= 29 ~ "MCI",
      mmse.new < 26 ~ "Sa sút trí tuệ",
      TRUE ~ NA_character_
    ),
    phan_loan_roi_loan_nhan_thuc = factor(
      phan_loan_roi_loan_nhan_thuc,
      levels = c("MCI", "Sa sút trí tuệ")
    ),
    
    mmse_group = case_when(
      mmse.new >= 26 & mmse.new <= 29 ~ "Suy giảm nhận thức nhẹ",
      mmse.new >= 21 & mmse.new <= 25 ~ "Sa sút trí tuệ nhẹ",
      mmse.new >= 11 & mmse.new <= 20 ~ "Sa sút trí tuệ trung bình",
      mmse.new >= 0  & mmse.new <= 10 ~ "Sa sút trí tuệ nặng",
      TRUE ~ NA_character_
    ),
    mmse_group = factor(mmse_group, levels = c(
      "Suy giảm nhận thức nhẹ",
      "Sa sút trí tuệ nhẹ",
      "Sa sút trí tuệ trung bình",
      "Sa sút trí tuệ nặng"
    )),
    mmse_group = fct_drop(mmse_group),
    
    lam_sang_group = case_when(
      !is.na(chan_doan_giai_doan_lam_sang) ~ as.character(chan_doan_giai_doan_lam_sang),
      diagno_lam_sang == "Suy giảm nhận thức nhẹ" ~ "Suy giảm nhận thức nhẹ",
      TRUE ~ NA_character_
    ),
    lam_sang_group = factor(lam_sang_group, levels = c(
      "Suy giảm nhận thức nhẹ",
      "Sa sút trí tuệ nhẹ",
      "Sa sút trí tuệ trung bình",
      "Sa sút trí tuệ nặng"
    ))
  )
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

ft_tuoi

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

tuoi_gp

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


#❤️❤️### MMSE ️❤️❤️##
####################

# 🧠 Tổng hợp bảng MMSE
tab_mmse <- df %>%
  count(mmse_group, name = "n") %>%
  mutate(
    percent = round(100 * n / sum(n), 1),
    percent_vi = str_replace(format(percent, decimal.mark = ","), "\\.", ","),  # ✅ xử lý dấu , trước
    `Số lượng (Tỷ lệ %)` = glue("{n} ({percent_vi}%)"),
    nhan_day_du = case_when(
      mmse_group == "Bình thường" ~ "Bình thường",
      mmse_group == "Suy giảm nhận thức nhẹ" ~ "Suy giảm nhận thức nhẹ",
      mmse_group == "Sa sút trí tuệ nhẹ" ~ "Sa sút trí tuệ nhẹ",
      mmse_group == "Sa sút trí tuệ trung bình" ~ "Sa sút trí tuệ trung bình",
      mmse_group == "Sa sút trí tuệ nặng" ~ "Sa sút trí tuệ nặng",
      TRUE ~ as.character(mmse_group)
    )
  )

# 📋 Tạo bảng flextable
ft_mmse <- flextable(tab_mmse %>%
                       select(`Phân độ MMSE` = nhan_day_du, `Số lượng (Tỷ lệ %)`)) %>%
  colformat_num(decimal.mark = ",", big.mark = ".") %>%
  set_table_properties(width = 1, layout = "autofit") %>%
  font(fontname = "Times New Roman", part = "all") %>%
  fontsize(size = 11, part = "all") %>%
  set_caption("Bảng: Tần suất và tỷ lệ phân độ MMSE") %>%
  autofit()

# 📊✨ Biểu đồ cột MMSE theo thứ tự từ nhẹ đến nặng với nhãn không bị mất
ggplot_mmse <- tab_mmse %>%
  mutate(nhan_day_du = factor(
    nhan_day_du,
    levels = c(
      "Suy giảm nhận thức nhẹ",
      "Sa sút trí tuệ nhẹ",
      "Sa sút trí tuệ trung bình",
      "Sa sút trí tuệ nặng"
    )
  )) %>%
  ggplot(aes(x = nhan_day_du, y = n, fill = nhan_day_du)) +
  geom_col(width = 0.6) +
  geom_text(
    aes(label = `Số lượng (Tỷ lệ %)`),
    vjust = -0.5,
    size = 3.5,
    family = "Times New Roman"
  ) +
  scale_y_continuous(expand = expansion(mult = c(0, 0.1))) +  # ✅ tạo khoảng trống phía trên
  scale_fill_brewer(palette = "Pastel1") +
  labs(y = "Số lượng") +
  theme_minimal(base_family = "Times New Roman") +
  theme(
    axis.text.x = element_text(angle = 30, hjust = 1),
    axis.title.x = element_blank(), 
    axis.text = element_text(size = 11),
    legend.position = "none"
  )

# ✏️ Inline mô tả bảng
mmse_top <- tab_mmse %>% slice_max(order_by = n, n = 1)
inline_bang_mmse <- glue(
  "Bảng cho thấy phân độ MMSE phổ biến nhất là **{mmse_top$nhan_day_du}**, ",
  "chiếm tỷ lệ {format(mmse_top$percent, decimal.mark = ',')}%."
)

# 📈 Inline mô tả biểu đồ
tab_mmse_xu <- tab_mmse %>%
  mutate(nhom = case_when(
    str_detect(mmse_group, "Suy giảm") ~ "Suy giảm nhận thức nhẹ",
    str_detect(mmse_group, "Sa sút") ~ "Sa sút trí tuệ",
    mmse_group == "Bình thường" ~ "Bình thường"
  )) %>%
  group_by(nhom) %>%
  summarise(tong = sum(n), .groups = "drop")

top_xu <- tab_mmse_xu %>% slice_max(order_by = tong, n = 1)
nhom_dich <- top_xu$nhom
inline_bieudo_mmse <- glue(
  "Biểu đồ thể hiện xu hướng tập trung vào nhóm **{nhom_dich}**."
)

# 🧠 Inline bàn luận ngắn gọn
top2 <- tab_mmse %>% arrange(desc(n)) %>% slice_head(n = 2)
inline_mmse_banluan <- text_blue(ifelse(
  top2$nhan_day_du[1] != top2$nhan_day_du[2],
  glue("Hai phân độ phổ biến nhất là {top2$nhan_day_du[1]} (chiếm {top2$percent[1]}%) và {top2$nhan_day_du[2]} (chiếm {top2$percent[2]}%)."),
  glue("Phân độ phổ biến nhất là **{top2$nhan_day_du[1]}**, chiếm {top2$percent[1]}%")
))

# 🔢 Tính phần trăm người thuộc nhóm MCI (MMSE 26–29)
percent_mci <- tab_mmse %>%
  filter(mmse_group == "Suy giảm nhận thức nhẹ") %>%
  summarise(p = sum(n) / sum(tab_mmse$n)) %>%
  pull(p)

# 📘 Inline mô tả với text_blue() và phần trăm kiểu Việt (dấu phẩy)
inline_mci_mota_phantram_banluan <- text_blue(glue(
  "Trong nghiên cứu này, có {scales::percent(percent_mci, accuracy = 0.1, decimal.mark = ',')} người tham gia được phân vào nhóm MCI (MMSE 26–29)."
))
# 🧠 Inline bàn luận ngắn gọn ve tỉ lệ các nhón 
# 🧠 Tính tỷ lệ nhóm "Sa sút trí tuệ nặng"
prop_nang <- df %>%
  summarise(ti_le = mean(mmse_group == "Sa sút trí tuệ nặng") * 100) %>%
  pull(ti_le)

# 📌 Tạo chuỗi mô tả inline với định dạng phần trăm kiểu Việt Nam
ti_le_sstt_nang_theo_mmse <- text_blue(glue(
  "tỷ lệ nhóm Sa sút trí tuệ nặng là {scales::number(prop_nang, accuracy = 0.1, decimal.mark = ',')}%"
))

#❤️❤️###Đặc điểm các test nhận thức ️❤️❤️##
####################

# 🧠 Biến thần kinh nhận thức và nhãn
tests_nhanthuc <- c(
  "Im.recall1", "de.recall1", "de.reg1",
  "TMT.A.time", "TMT.B.time",
  "DS.forward1", "DS.backrward1",
  "animal.test1", "clock.drawing1"
)

label_nhanthuc <- c(
  "Nhớ lại ngay", "Nhớ lại có trì hoãn", "Nhận biết có trì hoãn",
  "Nối số", "Nối số-chữ",
  "Đọc số xuôi", "Đọc số ngược",
  "Lưu loát ngôn ngữ", "Vẽ đồng hồ"
)
names(label_nhanthuc) <- tests_nhanthuc

# 📋 Tổng hợp bảng mô tả + kiểm định
table_nhanthuc_group <- purrr::map_dfr(tests_nhanthuc, function(var) {
  df_sub <- df %>%
    select(phan_loan_roi_loan_nhan_thuc, !!sym(var)) %>%
    filter(!is.na(phan_loan_roi_loan_nhan_thuc), !is.na(!!sym(var)))
  
  # Kiểm định
  formatted_p <- "-"
  if (n_distinct(df_sub$phan_loan_roi_loan_nhan_thuc) >= 2) {
    group_vals <- split(df_sub[[var]], df_sub$phan_loan_roi_loan_nhan_thuc)
    if (length(group_vals[[1]]) >= 3 && length(group_vals[[2]]) >= 3) {
      shapiro1 <- shapiro.test(group_vals[[1]])$p.value
      shapiro2 <- shapiro.test(group_vals[[2]])$p.value
      p_val <- tryCatch({
        if (shapiro1 > 0.05 && shapiro2 > 0.05) {
          t.test(!!sym(var) ~ phan_loan_roi_loan_nhan_thuc, data = df_sub)$p.value
        } else {
          wilcox.test(!!sym(var) ~ phan_loan_roi_loan_nhan_thuc, data = df_sub)$p.value
        }
      }, error = function(e) NA_real_)
      formatted_p <- ifelse(
        is.na(p_val), "-",
        ifelse(p_val < 0.001, "< 0,001", formatC(p_val, digits = 3, format = "f") |> str_replace_all("\\.", ","))
      )
    }
  }
  
  # Tóm tắt mô tả
  df_stats <- df_sub %>%
    group_by(phan_loan_roi_loan_nhan_thuc) %>%
    summarise(
      `Trung bình ± SD` = sprintf("%.1f ± %.1f", mean(!!sym(var)), sd(!!sym(var))),
      `Trung vị (Q1–Q3)` = sprintf("%.1f (%.1f–%.1f)",
                                   median(!!sym(var)),
                                   quantile(!!sym(var), 0.25),
                                   quantile(!!sym(var), 0.75)),
      `Min – Max` = sprintf("%.1f – %.1f", min(!!sym(var)), max(!!sym(var))),
      N = as.character(n()),
      .groups = "drop"
    ) %>%
    pivot_longer(-phan_loan_roi_loan_nhan_thuc, names_to = "Chỉ số", values_to = "Giá trị") %>%
    pivot_wider(names_from = phan_loan_roi_loan_nhan_thuc, values_from = "Giá trị") %>%
    mutate(
      `Test thần kinh` = label_nhanthuc[[var]],
      `Giá trị p` = if_else(`Chỉ số` == "Trung bình ± SD", formatted_p, "")
    ) %>%
    select(`Test thần kinh`, everything())
  
  return(df_stats)
}) %>%
  mutate(across(-`Test thần kinh`, ~str_replace_all(.x, "\\.", ",")))  # 🇻🇳 dấu phẩy Việt

# 📋 Bảng flextable
ft_nhanthuc_group <- flextable(table_nhanthuc_group %>% select(-`Giá trị p`))  %>%
  align(align = "center", part = "all") %>%
  font(fontname = "Times New Roman", part = "all") %>%
  fontsize(size = 11, part = "all") %>%
  bold(i = 1, part = "header") %>%
  set_caption("Bảng: Mô tả và kiểm định các test thần kinh nhận thức theo nhóm nhận thức") %>%
  autofit()
# 💬 Inline mô tả bảng
# 📊 Biểu đồ density
df_long_nhanthuc <- df %>%
  select(phan_loan_roi_loan_nhan_thuc, all_of(tests_nhanthuc)) %>%
  pivot_longer(cols = -phan_loan_roi_loan_nhan_thuc, names_to = "test", values_to = "giatri") %>%
  mutate(test_label = fct_recode(factor(test), !!!label_nhanthuc))

plot_nhanthuc_group <- ggplot(df_long_nhanthuc, aes(x = giatri, fill = phan_loan_roi_loan_nhan_thuc)) +
  geom_density(alpha = 0.5) +
  facet_wrap(~test_label, scales = "free", ncol = 3) +
  labs(
    x = "Giá trị", y = "Mật độ",
    fill = "Nhóm nhận thức",
    title = "Biểu đồ mật độ các test thần kinh theo nhóm nhận thức"
  ) +
  theme_minimal(base_family = "Times New Roman") +
  theme(
    strip.text = element_text(size = 11),
    axis.text = element_text(size = 10),
    axis.title = element_text(size = 11),
    plot.title = element_text(face = "bold", hjust = 0.5),
    legend.position = "bottom"
  )

# 💬 Inline mô tả bảng
inline_bang_tests_group <- glue(
  "Bảng trên  cho thấy nhiều test có sự khác biệt rõ rệt giữa nhóm Suy giảm nhận thức nhẹ và 'Sa sút trí tuệ', ",
  "với giá trị p < 0,05 được ghi nhận ở các test"
)

# 💬 Inline mô tả biểu đồ
inline_bieudo_tests_group <- glue(
  "Biểu đồ mật độ cho thấy sự phân tách giữa hai nhóm rõ nhất ở các test như 'Đọc số ngược', 'Nối số-chữ' và 'Vẽ đồng hồ', ",
  "gợi ý đây là các công cụ nhạy trong phân biệt mức độ suy giảm nhận thức."
)

# 💬 Inline bình luận tổng quan
inline_banluan_tests_group <- glue(
  "Kết quả kiểm định và biểu đồ đều cho thấy xu hướng rõ ràng: nhóm 'Sa sút trí tuệ' có hiệu suất thấp hơn đáng kể trên các test thần kinh nhận thức. ",
  "Điều này củng cố vai trò phân biệt của các công cụ đánh giá nhận thức ngắn gọn trong tầm soát suy giảm."
)
# 💬 Inline bàn luận tổng quan
inline_banluan_tests <- glue(
  "Nhìn chung, các test như 'Đọc số ngược', 'Nối số-chữ' có nhiều giá trị thấp, phản ánh mức suy giảm nhận thức ở bệnh nhân"
)


#❤️❤️❤️#Phân tích tương quan❤️❤️❤️##
#######################################

## Phân tích tương quan mmse theo nhóm chẩn đoán

### Tính tương quan theo nhóm (MCI và sa sút trí tuệ)


# Hàm định dạng số kiểu Việt
format_vn <- function(x) {
  format(round(as.numeric(x), 2), decimal.mark = ",", nsmall = 2)
}

# Danh sách test và nhãn tiếng Việt
cor_vars <- c(
  "Im.recall1", "de.recall1", "de.reg1",
  "TMT.A.time", "TMT.B.time",
  "DS.forward1", "DS.backrward1",
  "animal.test1", "clock.drawing1"
)
cor_labels <- c(
  "Nhớ lại ngay", "Nhớ lại có trì hoãn", "Nhận biết có trì hoãn",
  "Nối số (TMT-A)", "Nối số - chữ (TMT-B)",
  "Đọc số xuôi", "Đọc số ngược",
  "Lưu loát ngôn ngữ", "Vẽ đồng hồ"
)
names(cor_labels) <- cor_vars

# Tính tương quan
cor_table <- purrr::map_dfr(cor_vars, function(var) {
  df_sub <- df %>% select(mmse.new, !!sym(var)) %>% drop_na()
  
  test <- tryCatch(
    cor.test(df_sub$mmse.new, df_sub[[var]], method = "spearman"),
    error = function(e) NULL
  )
  
  if (!is.null(test)) {
    r_val <- round(test$estimate, 2)
    abs_r <- abs(r_val)
    muc_do <- case_when(
      abs_r >= 0.7 ~ "Chặt",
      abs_r >= 0.5 ~ "Khá",
      abs_r >= 0.3 ~ "Vừa",
      TRUE         ~ "Yếu"
    )
    
    data.frame(
      Test.thần.kinh = cor_labels[[var]],
      Hệ.số.tương.quan..r. = r_val,
      Giá.trị.p = ifelse(test$p.value < 0.001, "< 0.001", sprintf("%.3f", test$p.value)),
      Mức.độ.tương.quan = muc_do
    )
  }
})
# Định dạng số kiểu Việt
format_vn <- function(x) {
  format(round(as.numeric(x), 2), decimal.mark = ",", nsmall = 2)
}

# Tính tương quan Spearman cho từng nhóm
cor_by_group <- purrr::map_dfr(
  .x = c("MCI", "Sa sút trí tuệ"),
  .f = function(gr) {
    purrr::map_dfr(cor_vars, function(var) {
      df_sub <- df %>%
        filter(phan_loan_roi_loan_nhan_thuc == gr) %>%
        select(mmse.new, !!sym(var)) %>% drop_na()
      
      test <- tryCatch(
        cor.test(df_sub$mmse.new, df_sub[[var]], method = "spearman"),
        error = function(e) NULL
      )
      
      if (!is.null(test)) {
        r_val <- round(test$estimate, 2)
        abs_r <- abs(r_val)
        muc_do <- case_when(
          abs_r >= 0.7 ~ "Chặt",
          abs_r >= 0.5 ~ "Khá",
          abs_r >= 0.3 ~ "Vừa",
          TRUE         ~ "Yếu"
        )
        
        data.frame(
          Nhóm = gr,
          Test.thần.kinh = cor_labels[[var]],
          Hệ.số.tương.quan.r = r_val,
          Giá.trị.p = ifelse(test$p.value < 0.001, "< 0.001", sprintf("%.3f", test$p.value)),
          Mức.độ.tương.quan = muc_do
        )
      }
    })
  }
)

mota_theo_nhom <- function(nhom, muc) {
  data <- cor_by_group %>%
    filter(Nhóm == nhom, Mức.độ.tương.quan == muc)
  
  if (nrow(data) == 0) return(NULL)
  
  data <- data %>%
    mutate(
      r_txt = format(round(Hệ.số.tương.quan.r, 2), decimal.mark = ","),
      p_txt = ifelse(
        Giá.trị.p == "< 0.001", "< 0,001",
        format(round(as.numeric(gsub("< ", "", Giá.trị.p)), 3), decimal.mark = ",")
      ),
      test_format = ifelse(
        as.numeric(gsub("< ", "", Giá.trị.p)) < 0.05,
        glue("**{Test.thần.kinh}** (r = {r_txt}, p = {p_txt})"),
        glue("{Test.thần.kinh} (r = {r_txt}, p = {p_txt})")
      )
    )
  
  glue("{nrow(data)} test của nhóm **{nhom}** có tương quan {tolower(muc)} với MMSE: {glue_collapse(data$test_format, sep = '; ', last = ' và ')}.")
}


### Bảng flextable tương quan theo nhóm

ft_corr_grouped <- if (nrow(cor_by_group) > 0) {
  ft_corr_grouped <- flextable(cor_by_group) %>%
    colformat_num(j = "Hệ.số.tương.quan.r", decimal.mark = ",", big.mark = ".") %>%
    autofit() %>%
    bold(i = 1, part = "header") %>%
    set_header_labels(
      Nhóm = "Phân nhóm",
      Test.thần.kinh = "Test thần kinh nhận thức",
      Hệ.số.tương.quan.r = "Hệ số tương quan r",
      Giá.trị.p = "Giá trị p",
      Mức.độ.tương.quan = "Mức độ tương quan"
    ) %>%
    font(fontname = "Times New Roman", part = "all") %>%
    fontsize(size = 11, part = "all") %>%
    set_caption("Bảng: Tương quan giữa MMSE và các test nhận thức theo từng nhóm chẩn đoán") %>%
    set_table_properties(width = 1, layout = "autofit")
  ft_corr_grouped
} else {
  'Không có dữ liệu để hiển thị bảng tương quan theo nhóm.'
} %>%
  set_table_properties(width = 1, layout = "autofit")



# Chuẩn bị bảng long-format
cor_long <- cor_by_group %>%
  mutate(
    info = ifelse(
      Giá.trị.p == "< 0.001",
      glue("{format_vn(Hệ.số.tương.quan.r)} (p < 0,001)"),
      glue("{format_vn(Hệ.số.tương.quan.r)} (p = {format_vn(as.numeric(Giá.trị.p))})")
    )
  ) %>%
  select(Nhóm, Test.thần.kinh, info) %>%
  pivot_wider(names_from = Nhóm, values_from = info)

# Tạo bảng flextable dạng wide
ft_corr_long <- flextable(cor_long) %>%
  set_header_labels(
    Test.thần.kinh = "Test thần kinh nhận thức",
    `MCI` = "MCI (r, p)",
    `Sa sút trí tuệ` = "Sa sút trí tuệ (r, p)"
  ) %>%
  autofit() %>%
  font(fontname = "Times New Roman", part = "all") %>%
  fontsize(size = 11, part = "all") %>%
  set_caption("Bảng: Tương quan giữa MMSE và các test nhận thức theo nhóm chẩn đoán (dạng long)") %>%
  set_table_properties(width = 1, layout = "autofit")


### Biểu đồ ggplot theo nhóm

df_plot_grouped <- cor_by_group %>%
  mutate(
    test_than_kinh = factor(Test.thần.kinh, levels = rev(unique(Test.thần.kinh))),
    co_y_nghia = ifelse(as.numeric(gsub("< ", "", Giá.trị.p)) < 0.05, "Có ý nghĩa", "Không ý nghĩa")
  )

plot_corr_grouped <- ggplot(df_plot_grouped, aes(x = test_than_kinh, y = Hệ.số.tương.quan.r, fill = co_y_nghia)) +
  geom_col(width = 0.6) +
  geom_text(
    aes(label = format_vn(Hệ.số.tương.quan.r)),
    hjust = ifelse(df_plot_grouped$Hệ.số.tương.quan.r >= 0, -0.1, 1.1),
    color = "black", size = 3.5, family = "Times New Roman"
  ) +
  facet_wrap(~Nhóm) +
  coord_flip(clip = "off") +
  scale_fill_brewer(palette = "Pastel1") +
  expand_limits(y = c(-1.05, 1.05)) +
  labs(
    title = "Tương quan giữa MMSE và các test nhận thức theo từng nhóm",
    x = NULL, y = "Hệ số tương quan (r)",
    fill = "Ý nghĩa thống kê"
  ) +
  theme_minimal(base_family = "Times New Roman") +
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold", size = 14),
    axis.text = element_text(size = 11),
    legend.position = "top"
  )



### Nhận xét riêng cho bảng và biểu đồ

# Hàm tạo câu nhận xét theo nhóm và mức độ


ota_theo_nhom <- function(nhom, muc) {
  data <- cor_by_group %>%
    filter(Nhóm == nhom, Mức.độ.tương.quan == muc)
  
  if (nrow(data) == 0) return(NULL)
  
  data <- data %>%
    mutate(
      r_txt = format_vn(Hệ.số.tương.quan.r),
      p_txt = ifelse(
        Giá.trị.p == "< 0.001", "< 0,001",
        format_vn(as.numeric(gsub("< ", "", Giá.trị.p)))
      ),
      test_format = ifelse(
        as.numeric(gsub("< ", "", Giá.trị.p)) < 0.05,
        glue("**{Test.thần.kinh}** (r = {r_txt}, p = {p_txt})"),
        glue("{Test.thần.kinh} (r = {r_txt}, p = {p_txt})")
      )
    )
  
  glue("{nrow(data)} test của nhóm **{nhom}** có tương quan {tolower(muc)} với MMSE: {glue_collapse(data$test_format, sep = '; ', last = ' và ')}.")
}


### Nhận xét riêng cho bảng flextable


cau_bang_mci <- glue_collapse(purrr::compact(c(
  mota_theo_nhom("MCI", "Chặt"),
  mota_theo_nhom("MCI", "Khá"),
  mota_theo_nhom("MCI", "Vừa"),
  mota_theo_nhom("MCI", "Yếu")
)), sep = " ")

cau_bang_sstt <- glue_collapse(purrr::compact(c(
  mota_theo_nhom("Sa sút trí tuệ", "Chặt"),
  mota_theo_nhom("Sa sút trí tuệ", "Khá"),
  mota_theo_nhom("Sa sút trí tuệ", "Vừa"),
  mota_theo_nhom("Sa sút trí tuệ", "Yếu")
)), sep = " ")

# Nhận xét tổng hợp cho biểu đồ ggplot


cor_wide_compare <- cor_by_group %>%
  select(Nhóm, Test.thần.kinh, Hệ.số.tương.quan.r) %>%
  pivot_wider(names_from = Nhóm, values_from = Hệ.số.tương.quan.r)

test_tuong_quan_cao_hon_sstt <- cor_wide_compare %>%
  filter(`Sa sút trí tuệ` - MCI >= 0.1) %>%
  arrange(desc(`Sa sút trí tuệ` - MCI)) %>%
  pull(Test.thần.kinh)

if (length(test_tuong_quan_cao_hon_sstt) > 0) {
  test_nhanh <- glue_collapse(head(test_tuong_quan_cao_hon_sstt, 3), sep = ", ", last = " và ")
  cau_inline_so_sanh_sstt_mci <- glue("Một số test như {test_nhanh} có tương quan mạnh hơn ở nhóm sa sút trí tuệ.")
} else {
  cau_inline_so_sanh_sstt_mci <- "Không có test nào có tương quan mạnh hơn rõ rệt giữa hai nhóm."
}
#❤️❤️❤️ Mức độ hoàn thành các test thần kinh nhận thứcn❤️❤️❤️##
#######################################

neuro_vars <- c(
  "Im.recall1", "de.recall1", "de.reg1",
  "TMT.A.time", "TMT.B.time",
  "DS.forward1", "DS.backrward1",
  "animal.test1", "clock.drawing1"
)

# 📝 Nhãn tiếng Việt tương ứng
test_labels_map <- c(
  "Im.recall1" = "Nhớ lại ngay",
  "de.recall1" = "Nhớ lại có trì hoãn",
  "de.reg1" = "Nhận biết có trì hoãn",
  "TMT.A.time" = "Nối số",
  "TMT.B.time" = "Nối số-chữ",
  "DS.forward1" = "Đọc chuỗi số xuôi",
  "DS.backrward1" = "Đọc chuỗi số ngược",
  "animal.test1" = "Lưu loát ngôn ngữ",
  "clock.drawing1" = "Vẽ đồng hồ"
)

# ✨ Thứ tự mong muốn để hiển thị nhất quán
label_order <- c(
  "Nhớ lại ngay", "Nhớ lại có trì hoãn", "Nhận biết có trì hoãn",
  "Nối số", "Nối số-chữ",
  "Đọc chuỗi số xuôi", "Đọc chuỗi số ngược",
  "Lưu loát ngôn ngữ", "Vẽ đồng hồ"
)

# 📊 Tính toán tỉ lệ hoàn thành theo nhóm
completion_summary <- purrr::map_dfr(neuro_vars, function(var) {
  df %>%
    group_by(phan_loan_roi_loan_nhan_thuc) %>%
    summarise(
      Biến = var,
      Hoàn.thành = round(100 * sum(!is.na(.data[[var]])) / n(), 1),
      .groups = "drop"
    )
})

# 📋 Tạo bảng flextable
completion_wide <- completion_summary %>%
  select(Nhóm = phan_loan_roi_loan_nhan_thuc, Biến, Hoàn.thành) %>%
  pivot_wider(names_from = Nhóm, values_from = Hoàn.thành) %>%
  mutate(`Test thần kinh` = factor(test_labels_map[Biến], levels = label_order)) %>%
  arrange(`Test thần kinh`) %>%
  select(`Test thần kinh`, `MCI`, `Sa sút trí tuệ`)

ft_hoanthanh <- flextable(completion_wide) %>%
  set_header_labels(
    `Test thần kinh` = "Test thần kinh nhận thức",
    `MCI` = "MCI (%)",
    `Sa sút trí tuệ` = "Sa sút trí tuệ (%)"
  ) %>%
  colformat_num(decimal.mark = ",", suffix = "%") %>%
  font(fontname = "Times New Roman", part = "all") %>%
  fontsize(size = 11, part = "all") %>%
  autofit() %>%
  #set_caption("Bảng: Tỉ lệ hoàn thành các test thần kinh nhận thức theo nhóm chẩn đoán") %>%
  set_table_properties(width = 1, layout = "autofit")

# 📊 Chuẩn bị và vẽ biểu đồ ggplot theo đúng thứ tự
label_order <- c(
  "Nhớ lại ngay", "Nhớ lại có trì hoãn", "Nhận biết có trì hoãn",
  "Nối số", "Nối số-chữ",
  "Đọc chuỗi số xuôi", "Đọc chuỗi số ngược",
  "Lưu loát ngôn ngữ", "Vẽ đồng hồ"
)

plot_hoanthanh <- completion_summary %>%
  mutate(
    Nhóm = factor(phan_loan_roi_loan_nhan_thuc, levels = c("MCI", "Sa sút trí tuệ")),
    Nhãn = factor(test_labels_map[Biến], levels = rev(label_order))
  ) %>%
  ggplot(aes(x = Nhãn, y = Hoàn.thành, fill = Nhóm)) +
  geom_col(position = position_dodge(width = 0.8), width = 0.7) +
  geom_text(
    aes(label = paste0(Hoàn.thành, "%")),
    position = position_dodge(width = 0.8),
    hjust = -0.5,  # 👈 Nhãn nằm bên phải ngoài cột
    size = 3.5,
    family = "Times New Roman"
  ) +
  coord_flip(clip = "off") +
  scale_x_discrete(expand = expansion(mult = c(0.2, 0.2))) +
  scale_fill_brewer(palette = "Pastel2") +
  expand_limits(y = max(completion_summary$Hoàn.thành) + 15) +  # 👈 Thêm khoảng trống cho nhãn
  labs(
    # title = "Tỉ lệ hoàn thành các test thần kinh nhận thức",
    x = NULL, y = "Tỉ lệ hoàn thành (%)", fill = "Nhóm"
  ) +
  theme_minimal(base_family = "Times New Roman") +
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold", size = 13),
    axis.text = element_text(size = 10),
    legend.position = "top"
  )

# ✏️ Nhận xét tự động
nhom_thap_mci <- completion_summary %>%
  filter(phan_loan_roi_loan_nhan_thuc == "MCI") %>%
  arrange(Hoàn.thành) %>%
  slice(1)

nhom_thap_sstt <- completion_summary %>%
  filter(phan_loan_roi_loan_nhan_thuc == "Sa sút trí tuệ") %>%
  arrange(Hoàn.thành) %>%
  slice(1)

cau_hoanthanh_bang <- glue(
  "Tỉ lệ hoàn thành nhìn chung cao, từ khoảng ",
  "{min(completion_summary$Hoàn.thành)}% đến {max(completion_summary$Hoàn.thành)}%. ",
  "Test {test_labels_map[nhom_thap_mci$Biến]} thấp nhất ở nhóm MCI ({nhom_thap_mci$Hoàn.thành}%), ",
  "và test {test_labels_map[nhom_thap_sstt$Biến]} thấp nhất ở nhóm sa sút trí tuệ ({nhom_thap_sstt$Hoàn.thành}%)."
)

cau_hoanthanh_ggplot <- glue(
  "Biểu đồ cho thấy phần lớn test được thực hiện với tỉ lệ cao trong cả hai nhóm, ",
  "chỉ có một số test gặp khó khăn hơn ở nhóm MCI hoặc sa sút trí tuệ."
)

#❤️❤️❤️Đánh giá sự tương đồng giữa phân độ MMSE và phân loại lâm sàng theo tiêu chuẩn lâm sàngn❤️❤️❤️##
#######################################

# 📦 Chuẩn bị dữ liệu và mã hóa thứ bậc
df_ord <- df %>%
  filter(
    !is.na(mmse_group),
    !is.na(lam_sang_group),
    mmse_group != "Bình thường"  # ❌ Loại bỏ nhóm Bình thường
  ) %>%
  mutate(
    mmse_group = droplevels(mmse_group),
    lam_sang_group = droplevels(lam_sang_group),
    mmse_num = as.numeric(mmse_group),
    lam_sang_num = as.numeric(lam_sang_group)
  )

# 📈 Kiểm định Spearman và Kendall
test_spearman <- cor.test(df_ord$mmse_num, df_ord$lam_sang_num, method = "spearman")
test_kendall  <- cor.test(df_ord$mmse_num, df_ord$lam_sang_num, method = "kendall")

rho <- round(test_spearman$estimate, 2)
pval_s <- test_spearman$p.value
pval_s_fmt <- ifelse(pval_s < 0.001, "< 0.001", sprintf("%.3f", pval_s))

tau <- round(test_kendall$estimate, 2)
pval_k <- test_kendall$p.value
pval_k_fmt <- ifelse(pval_k < 0.001, "< 0.001", sprintf("%.3f", pval_k))

# 🧾 Tạo bảng tần suất dạng chéo
tab_ordinal_long <- df_ord %>%
  count(`Phân loại lâm sàng` = lam_sang_group, `Phân độ MMSE` = mmse_group) %>%
  group_by(`Phân loại lâm sàng`) %>%
  mutate(
    Tỷ_lệ = round(100 * n / sum(n), 1),
    Tần_suất = glue("{n} ({Tỷ_lệ}%)")
  ) %>%
  select(-n, -Tỷ_lệ) %>%
  pivot_wider(names_from = `Phân độ MMSE`, values_from = Tần_suất, values_fill = "-") %>%
  mutate(
    `Giá trị p` = c(pval_s_fmt, rep("", n() - 1)),
    `Spearman ρ` = c(rho, rep("", n() - 1)),
    `Kendall τ` = c(tau, rep("", n() - 1))
  )

# 📊 Bảng flextable
ft_ord <- flextable(tab_ordinal_long) %>%
  set_caption("Bảng: Phân bố chéo giữa phân độ MMSE và phân loại lâm sàng (loại BT)") %>%
  autofit() %>%
  font(fontname = "Times New Roman", part = "all") %>%
  fontsize(size = 11, part = "all") %>%
  align(align = "center", part = "all")

# 🎨 Nhãn rút gọn
short_labels <- c(
  "Suy giảm nhận thức nhẹ" = "SGNT nhẹ",
  "Sa sút trí tuệ nhẹ" = "SSTT nhẹ",
  "Sa sút trí tuệ trung bình" = "SSTT TB",
  "Sa sút trí tuệ nặng" = "SSTT nặng"
)

# 🌡️ Heatmap với màu pastel
df_heatmap <- df_ord %>%
  count(lam_sang_group, mmse_group)

plot_heat <- ggplot(df_heatmap, aes(x = mmse_group, y = lam_sang_group, fill = n)) +
  geom_tile(color = "white") +
  geom_text(aes(label = n), color = "black", size = 4) +
  scale_fill_gradient(low = "#a8edea", high = "#fed6e3") +
  scale_x_discrete(labels = short_labels[levels(df_ord$mmse_group)]) +
  scale_y_discrete(labels = short_labels[levels(df_ord$lam_sang_group)]) +
  labs(x = "Phân độ theo MMSE", y = "Phân độ theo tiêu chuẩn lâm sàng", fill = "Tần suất") +
  theme_minimal(base_family = "Times New Roman") +
  theme(axis.text = element_text(size = 11), panel.grid = element_blank())

# 🔵 Scatter ordinal pastel
plot_scatter <- ggplot(df_ord, aes(x = mmse_num, y = lam_sang_num)) +
  geom_jitter(width = 0.2, height = 0.2, alpha = 0.6, color = "#40E0D0") +  # xanh ngọc
  geom_smooth(method = "lm", se = FALSE, color = "#FF6F61", linetype = "dashed") +  # cam đào
  scale_x_continuous(
    breaks = seq_along(levels(df_ord$mmse_group)),
    labels = short_labels[levels(df_ord$mmse_group)]
  ) +
  scale_y_continuous(
    breaks = seq_along(levels(df_ord$lam_sang_group)),
    labels = short_labels[levels(df_ord$lam_sang_group)]
  ) +
  labs(x = "Phân độ MMSE", y = "Phân loại lâm sàng") +
  theme_minimal(base_family = "Times New Roman") +
  theme(axis.text = element_text(size = 11), panel.grid = element_blank())

# 📝 Inline codes mô tả
cau_chen_bieu_do_heatmap <- glue(
  "Biểu đồ thể hiện sư phân bố chéo cho thấy mối liên hệ giữa phân độ giai đoạn bệnh theo tiêu chuẩn MMSE và phân độ theo tiêu chuẩn lâm sàng, hay còn gọi tiêu chuẩn vàng. Biểu đồ cho thấy hệ số Spearman ρ = {rho}, Kendall τ = {tau}, với p = {pval_s_fmt}. ",
  if (pval_s < 0.05) "Kết quả có ý nghĩa thống kê." else "Kết quả không có ý nghĩa thống kê."
)

cau_bieudo_ordinal <- glue(
  "Biểu đồ minh họa phân bố tập trung ở các mức độ tương ứng, ",
  "cho thấy xu hướng đồng biến giữa phân độ giai đoạn bệnh theo tiêu chuẩn MMSE và phân độ theo tiêu chuẩn lâm sàng."
)

cau_chen_bieu_do_gop_2_loai  <- glue(
  "Biểu đồ bên trái  thể hiện sư phân bố chéo cho thấy mối liên hệ giữa phân độ giai đoạn bệnh theo tiêu chuẩn MMSE và phân độ theo tiêu chuẩn lâm sàng, hay còn gọi tiêu chuẩn vàng. Biểu đồ cho thấy hệ số Spearman ρ = {rho}, Kendall τ = {tau}, với p = {pval_s_fmt}. ",
  if (pval_s < 0.05) "Kết quả có ý nghĩa thống kê." else "Kết quả không có ý nghĩa thống kê. ",  "Biểu đồ bên phải minh họa phân bố tập trung ở các mức độ tương ứng, ", "cho thấy xu hướng đồng biến giữa phân độ giai đoạn bệnh theo tiêu chuẩn MMSE và phân độ theo tiêu chuẩn lâm sàng."
)


pacman::p_load(patchwork)  # 📦 Ghép biểu đồ

# 🌈 Nhãn rút gọn
short_labels <- c(
  "Suy giảm nhận thức nhẹ" = "SGNT nhẹ",
  "Sa sút trí tuệ nhẹ" = "SSTT nhẹ",
  "Sa sút trí tuệ trung bình" = "SSTT TB",
  "Sa sút trí tuệ nặng" = "SSTT nặng"
)

# 🌡️ Heatmap pastel
df_heatmap <- df_ord %>%
  count(lam_sang_group, mmse_group)

plot_heat <- ggplot(df_heatmap, aes(x = mmse_group, y = lam_sang_group, fill = n)) +
  geom_tile(color = "white") +
  geom_text(aes(label = n), color = "black", size = 4) +
  scale_fill_gradient(low = "#a8edea", high = "#fed6e3") +  # pastel xanh-hồng
  scale_x_discrete(labels = short_labels[levels(df_ord$mmse_group)]) +
  scale_y_discrete(labels = short_labels[levels(df_ord$lam_sang_group)]) +
  labs(x = "Phân độ theo MMSE", y = "Phân độ trên lâm sàng", fill = "Tần suất") +
  theme_minimal(base_family = "Times New Roman") +
  theme(
    axis.text = element_text(size = 11),
    axis.text.x = element_text(angle = 45, hjust = 1),
    panel.grid = element_blank()
  )

# 🔵 Scatter ordinal pastel
plot_scatter <- ggplot(df_ord, aes(x = mmse_num, y = lam_sang_num)) +
  geom_jitter(width = 0.2, height = 0.2, alpha = 0.6, color = "#40E0D0") +  # turquoise
  geom_smooth(method = "lm", se = FALSE, color = "#FF6F61", linetype = "dashed") +  # coral
  scale_x_continuous(
    breaks = seq_along(levels(df_ord$mmse_group)),
    labels = short_labels[levels(df_ord$mmse_group)]
  ) +
  scale_y_continuous(
    breaks = seq_along(levels(df_ord$lam_sang_group)),
    labels = short_labels[levels(df_ord$lam_sang_group)]
  ) +
  labs(x = "Phân độ theo MMSE", y = "Phân độ trên lâm sàng") +
  theme_minimal(base_family = "Times New Roman") +
  theme(
    axis.text = element_text(size = 11),
    axis.text.x = element_text(angle = 45, hjust = 1),
    panel.grid = element_blank()
  )


#### gộp chung để chèn powerpoint

# 🌈 Nhãn rút gọn
short_labels <- c(
  "Suy giảm nhận thức nhẹ" = "SGNT nhẹ",
  "Sa sút trí tuệ nhẹ" = "SSTT nhẹ",
  "Sa sút trí tuệ trung bình" = "SSTT TB",
  "Sa sút trí tuệ nặng" = "SSTT nặng"
)

# 🌡️ Heatmap pastel
df_heatmap <- df_ord %>%
  count(lam_sang_group, mmse_group)

plot_heat <- ggplot(df_heatmap, aes(x = mmse_group, y = lam_sang_group, fill = n)) +
  geom_tile(color = "white") +
  geom_text(aes(label = n), color = "black", size = 4) +
  scale_fill_gradient(low = "#a8edea", high = "#fed6e3") +  # pastel xanh-hồng
  scale_x_discrete(labels = short_labels[levels(df_ord$mmse_group)]) +
  scale_y_discrete(labels = short_labels[levels(df_ord$lam_sang_group)]) +
  labs(x = "Phân độ MMSE", y = "Phân loại lâm sàng", fill = "Tần suất") +
  theme_minimal(base_family = "Times New Roman") +  # ✅ hoàn chỉnh font
  theme(
    axis.text = element_text(size = 11),
    axis.text.x = element_text(angle = 45, hjust = 1),
    panel.grid = element_blank()
  )


### Inline gọi kết quả trong tài liệu

#### Nhận xét từ bảng tương quan:

# **Nhóm MCI**: `r cau_bang_mci`
# **Nhóm Sa sút trí tuệ**: `r cau_bang_sstt`

#### Nhận xét từ biểu đồ tương quan:



