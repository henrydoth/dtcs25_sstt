# ❤️ Nếu chưa có %>% hoặc df → nạp packages và dữ liệu
if (!exists("%>%") || !exists("df")) {
  source(here::here("R", "packages.R"))
  source(here::here("R", "01_load_clean_data.R"))
}

#❤️❤️### MMSE ️❤️❤️##
####################

# 🧠 ßTổng hợp bảng MMSE
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
