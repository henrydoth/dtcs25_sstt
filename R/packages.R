pacman::p_load(
  dplyr, tidyr, forcats, haven,
  ggplot2, lubridate, glue, flextable,
  officer, officedown, jpeg, png, grid,
  tidyverse, magrittr,  
  purrr, RColorBrewer, emo, janitor,
  effectsize, patchwork, scales, stringr
)

set_flextable_defaults(
  font.family = "Times New Roman",
  font.size = 11,
  align = "center",
  padding = 3,
  theme_fun = theme_booktabs,
  layout = "autofit",
  width = 1,
  decimal.mark = ",",
  big.mark = ".",
  na_str = "-"
)

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

knitr::opts_chunk$set(
  fig.align = "center",
  out.width = "100%",
  fig.asp = 0.618
)

options(OutDec = ",")

scale_color_discrete <- function(...) scale_color_brewer(palette = "Set1", ...)
scale_fill_discrete  <- function(...) scale_fill_brewer(palette = "Pastel2", ...)

ft_vn <- function(df) {
  flextable(df) %>%
    colformat_num(decimal.mark = ",", big.mark = ".", na_str = "-") %>%
    autofit()
}

text_blue <- function(text) {
  ftext(
    text,
    fp_text_lite(
      color = "blue",
      font.family = "Times New Roman"
    )
  )
}

# 👉 Hàm kiểm tra và nạp lại packages nếu cần
check_and_load <- function() {
  if (!exists("%>%") || !exists("theme_set", mode = "function")) {
    message("📦 Nạp lại thư viện từ packages.R...")
    source(here::here("R", "packages.R"))
  }
}

# 👉 Hàm kiểm tra và nạp packages + dữ liệu nếu thiếu
check_and_load_all <- function() {
  if (!exists("%>%")) {
    message("📦 Thiếu pipe (%>%) → nạp lại packages.R...")
    source(here::here("R", "packages.R"))
  }
  if (!exists("df") || !inherits(df, "data.frame")) {
    message("📂 Thiếu dữ liệu df → nạp lại 01_load_clean_data.R...")
    source(here::here("R", "01_load_clean_data.R"))
  }
}
