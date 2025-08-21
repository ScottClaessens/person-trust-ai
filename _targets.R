library(targets)
library(tarchetypes)
library(tidyverse)

# load packages and scripts
tar_option_set(packages = c("tidyverse"))
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
        "Robot vacuum", "DeepSeek", "Robot soldier"
      )
    ),
    tar_target(plot_cor, plot_correlations(data, AI_type)),
    tar_target(plot_hist, plot_histograms(data, AI_type))
  ),
  # fit model 1 - predictors of trust
  #tar_map(
  #  values = tibble(
  #    predictor = c(
  #      "reliable", "competent", "genuine", "ethical", "autonomy",
  #      "potential_good", "potential_harm", "interpretability",
  #      "explainability", "humanlike", "predictability"
  #    )
  #  ),
  #  tar_target(fit1, fit_model1(data, predictor))
  #),
  # print session info for reproducibility
  tar_target(
    sessionInfo,
    writeLines(capture.output(sessionInfo()), "sessionInfo.txt")
  )
)
