# function to plot slope SDs
plot_slope_sd <- function(slope_sd_list) {
  # function to convert string
  convert_string <- function(x) {
    str_to_sentence(str_replace(x, "_", " "))
  }
  # bind rows
  d <-
    slope_sd_list %>%
    bind_rows() %>%
    unnest(post)
  # plot
  p <-
    d %>%
    mutate(
      predictor = convert_string(predictor),
      predictor = factor(
        predictor, levels = convert_string(unique(d$predictor))
      )
    ) %>%
    # plot
    ggplot(aes(x = post, y = fct_rev(predictor))) +
    stat_dist_slabinterval() +
    labs(
      title = "Variance in slopes across AI types for predictors of trust",
      x = "Estimate of standard deviation\nfor random slopes",
      y = NULL
    ) +
    theme_classic()
  # save and return
  ggsave(
    plot = p,
    filename = "plots/model1/variance.pdf",
    width = 5.5,
    height = 4
  )
  return(p)
}
