# function to fit model 1
fit_model1 <- function(data, predictor = "reliable") {
  # get model formula
  formula <- bf(
    paste0(
      "trust ~ 1 + ", predictor, " + (1 + ", predictor, " | type) + (1 | id)"
    )
  )
  # get priors
  prior <- c(
    prior(normal(0, 1), class = Intercept),
    prior(normal(0, 1), class = b),
    prior(exponential(2), class = sd),
    prior(lkj(3), class = cor)
  )
  # fit model
  brm(
    formula = formula,
    data = data,
    family = cumulative,
    prior = prior,
    cores = 4,
    seed = 2113
  )
}
