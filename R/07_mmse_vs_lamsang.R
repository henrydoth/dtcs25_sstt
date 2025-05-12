#❤️❤️## KIỂM TRA ️❤️❤️##
check_and_load_all <- function() {
  if (!exists("%>%") || !exists("theme_set", mode = "function"))
    source(here::here("R", "packages.R"), encoding = "UTF-8")
  if (!exists("df") || !inherits(df, "data.frame"))
    source(here::here("R", "01_load_clean_data.R"), encoding = "UTF-8")
}

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
