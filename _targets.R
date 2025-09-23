library(targets)
library(tarchetypes)
library(tidyverse)

# load packages and scripts
tar_option_set(packages = c("brms", "tidybayes", "tidyverse"))
tar_source()

# pipeline
list(
  # load data
  tar_target(data_file, "data/clean_data.csv", format = "file"),
  tar_target(data, load_data(data_file)),
  # plot AI usage
  tar_target(plot_usage, plot_AI_usage(data)),
  # plot correlations and histograms
  tar_map(
    values = tibble(
      AI_type = c(
        "General AI", "Autonomous killer drone",
        "Predictive sentencing algorithm", "Instagram filter", 
        "Self-driving car", "ChatGPT", "DALL-E", "AI superintelligence", 
        "Predictive policing algorithm", "Apple's Siri", "AI therapist",
        "Skin cancer diagnosis app", "Military cybersecurity AI",
        "Air traffic control AI", "Google Maps AI", "Audio transcription AI", 
        "Robot vacuum", "DeepSeek", "Robot soldier", "Facial recognition AI",
        "Medical triage AI"
      )
    ),
    tar_target(plot_cor, plot_correlations(data, AI_type)),
    tar_target(plot_hist, plot_histograms(data, AI_type))
  ),
  # fit model 0 - rankings
  tar_map(
    values = tibble(
      outcome = c(
        "trust", "reliable", "competent", "genuine", "ethical", "autonomy",
        "potential_good", "potential_harm", "interpretability",
        "explainability", "humanlike", "predictability"
      )
    ),
    tar_target(fit0, fit_model0(data, outcome)),
    tar_target(plot0, plot_model0(data, fit0, outcome))
  ),
  # fit model 1 - predictors of trust
  tar_map(
    values = tibble(
      predictor = c(
        "reliable", "competent", "genuine", "ethical", "autonomy",
        "potential_good", "potential_harm", "interpretability",
        "explainability", "humanlike", "predictability"
      )
    ),
    tar_target(fit1, fit_model1(data, predictor)),
    tar_target(plot1, plot_model1(fit1, predictor)),
    tar_target(slope_sd, extract_slope_sd(fit1, predictor))
  ),
  tar_target(
    plot_slope_sds,
    plot_slope_sd(
      list(
        slope_sd_reliable, slope_sd_competent, slope_sd_genuine,
        slope_sd_ethical, slope_sd_autonomy, slope_sd_potential_good,
        slope_sd_potential_harm, slope_sd_interpretability,
        slope_sd_explainability, slope_sd_humanlike, slope_sd_predictability
      )
    )
  ),
  # knit summary of results
  tar_quarto(summary, "quarto/summary/summary.qmd", quiet = FALSE),
  # print session info for reproducibility
  tar_target(
    sessionInfo,
    writeLines(capture.output(sessionInfo()), "sessionInfo.txt")
  )
)
