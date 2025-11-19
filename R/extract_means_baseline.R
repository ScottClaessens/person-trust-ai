# function to extract posterior means from baseline model
extract_means_baseline <- function(fit_baseline, outcome) {
  # extract model predictions
  newdata <- expand_grid(
    outcome = outcome,
    type = c(
      "General AI", "Autonomous killer drone",
      "Predictive sentencing algorithm", "Instagram filter", 
      "Self-driving car", "ChatGPT", "DALL-E", "AI superintelligence", 
      "Predictive policing algorithm", "Apple's Siri", "AI therapist",
      "Skin cancer diagnosis app", "Military cybersecurity AI",
      "Air traffic control AI", "Google Maps AI", "Audio transcription AI", 
      "Robot vacuum", "DeepSeek", "Robot soldier", "Facial recognition AI",
      "Medical triage AI"
    )
  )
  f <- fitted(
    object = fit_baseline,
    newdata = newdata,
    re_formula = ~ (1 | type),
    summary = FALSE
  )
  # calculate posterior means
  post <- matrix(0, nrow = nrow(f), ncol = ncol(f))
  for (i in 1:7) post <- post + (f[, , i] * i)
  # add posterior means to data
  newdata |>
    mutate(
      post = lapply(seq_len(ncol(post)), function(i) as.numeric(post[,i]))
    ) |>
    group_by(outcome, type) |>
    rowwise() |>
    summarise(
      post = list(post),
      Estimate = median(post),
      `2.5%` = quantile(post, 0.025),
      `97.5%` = quantile(post, 0.975)
    ) |>
    ungroup()
}
