# function to get the posterior distribution for the slope sd
extract_slope_sd <- function(fit1, predictor = "reliable") {
  # get posterior draws
  post <- posterior_samples(fit1)
  # return draws
  tibble(
    predictor = predictor,
    post = list(post[[paste0("sd_type__", predictor)]])
  )
}
