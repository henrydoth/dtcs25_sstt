

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

