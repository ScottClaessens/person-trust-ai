# function to load data and apply exclusion criteria
load_data <- function(data_file) {
  read_csv(
    file = data_file,
    show_col_types = FALSE
  ) |>
    # apply exclusion criteria
    filter(captcha >= 0.5 & attention == "TikTok") |>
    select(!c(captcha, attention))
}
