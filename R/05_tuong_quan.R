
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
