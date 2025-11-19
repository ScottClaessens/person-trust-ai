# function to impute data using mice
impute_data <- function(data, m) {
  # get predictor matrix
  pmat <- mice(data, maxit = 0)$pred
  # do not use id or block as predictors
  pmat[, colnames(pmat) %in% c("id", "block")] <- 0
  # impute data
  mice(
    data = data,
    m = m,
    predictorMatrix = pmat,
    printFlag = FALSE,
    seed = 2113
  )
}
