# function to fit baseline model
fit_baseline_model <- function(data, outcome = "trust") {
  # get model formula
  formula <- bf(paste0(outcome, " ~ 1 + (1 | type) + (1 | id)"))
  # get priors
  prior <- c(
    prior(normal(0, 1), class = Intercept),
    prior(exponential(2), class = sd)
  )
  # fit model
  brm(
    formula = formula,
    data = data,
    family = cumulative,
    prior = prior,
    cores = 4,
    iter = 3000,
    seed = 2113
  )
}
