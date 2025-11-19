# function to fit regression model to imputed data
fit_regression_model <- function(data_imputed, predictors) {
  # set up imputed data for modelling
  imp <- 
    data_imputed |>
    complete("long", include = TRUE) |>
    # center all predictors
    mutate(across(reliable:predictability, function(x) x - 4)) |>
    # compute composite predictors
    mutate(
      performance = (reliable + competent) / 2,
      moral = (genuine + ethical) / 2
    ) |>
    as.mids()
  # get model formula
  formula <- bf(
    paste0(
      "trust ~ 1 + ", predictors, " + (1 | id) + (1 + ", predictors, " | type)"
    )
  )
  # get priors
  prior <- c(
    prior(normal(0, 1), class = Intercept),
    prior(normal(0, 1), class = b),
    prior(exponential(2), class = sd),
    prior(lkj(2), class = cor)
  )
  # fit model in parallel
  plan(multisession, workers = 10)
  brm_multiple(
    formula = formula,
    data = imp,
    family = cumulative,
    prior = prior,
    chains = 2,
    iter = 3000,
    seed = 2113
  )
}
