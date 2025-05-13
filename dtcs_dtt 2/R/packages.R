if (!require("pacman")) install.packages("pacman")

pacman::p_load(
  dplyr, tidyr, forcats, haven,
  ggplot2, lubridate, glue, flextable,
  officer, officedown, jpeg, png, grid,
  tidyverse, purrr, RColorBrewer, janitor,
  effectsize, patchwork, scales, stringr
)
