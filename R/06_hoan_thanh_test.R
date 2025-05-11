
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
