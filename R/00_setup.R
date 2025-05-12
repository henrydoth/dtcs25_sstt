# ❤️ Nếu chưa có hàm now() thì nạp packages.R
if (!exists("now", mode = "function")) {
  source(here::here("R", "packages.R"))
}

##❤️❤️❤️##SETUP THOI GIAN#❤️❤️❤️#######
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




