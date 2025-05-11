
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
