# function to load data and apply exclusion criteria
load_data <- function(data_file) {
  read_csv(
    file = data_file,
    show_col_types = FALSE
  ) |>
    filter(captcha >= 0.5) |>
    filter(attention == "TikTok") |>
    select(!c(captcha, attention))
}
