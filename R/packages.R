if (!require("pacman")) install.packages("pacman")

pacman::p_load(
  dplyr, tidyr, forcats, haven,
  ggplot2, lubridate, glue, flextable,
  officer, officedown, jpeg, png, grid,
  tidyverse, purrr, RColorBrewer, emo, janitor,
  effectsize, patchwork, scales, stringr
)

# 📦 Thiết lập mặc định cho flextable
set_flextable_defaults(
  font.family = "Times New Roman",
  font.size = 11,
  align = "center",
  padding = 3,
  theme_fun = theme_booktabs,
  layout = "autofit",
  width = 1,
  decimal.mark = ",",     # ✅ Dấu phẩy kiểu Việt
  big.mark = ".",         # ✅ Ngăn cách hàng nghìn
  na_str = "-"            # ✅ Hiển thị NA là "-"
)

# 🎨 Thiết lập theme ggplot2 toàn cục
theme_set(
  theme_minimal(base_family = "Times New Roman") +
    theme(
      text = element_text(family = "Times New Roman"),
      plot.title = element_text(hjust = 0.5, face = "bold", size = 14),
      axis.title = element_text(size = 12),
      axis.text = element_text(size = 11),
      legend.text = element_text(size = 11),
      legend.title = element_text(size = 11),
      strip.text = element_text(size = 12)
    )
)

# 📊 Thiết lập chunk mặc định cho biểu đồ
knitr::opts_chunk$set(
  fig.align = "center",   # ✅ Căn giữa
  out.width = "100%",     # ✅ Fit chiều ngang Word
  fig.asp = 0.618
)

# 🔧 Các tùy chọn R chung
options(OutDec = ",")     # ✅ Dấu phẩy cho số thập phân

# 🎨 Ghi đè palette mặc định
scale_color_discrete <- function(...) scale_color_brewer(palette = "Set1", ...)
scale_fill_discrete  <- function(...) scale_fill_brewer(palette = "Pastel2", ...)


ft_vn <- function(df) {
  flextable(df) %>%
    colformat_num(decimal.mark = ",", big.mark = ".", na_str = "-") %>%
    autofit()
}


# Hàm tô màu xanh cho văn bản inline Word
text_blue <- function(text) {
  ftext(
    text,
    fp_text_lite(
      color = "blue",
      font.family = "Times New Roman"
    )
  )
}

