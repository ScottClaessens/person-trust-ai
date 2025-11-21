library(targets)
library(tarchetypes)
library(tidyverse)

# load packages and scripts
tar_option_set(
  packages = c("brms", "future", "mice", "patchwork", 
               "tidybayes", "tidyverse")
)
tar_source()

# pipeline
list(
  
  #### Load and summarise data ####
  
  # load data
  tar_target(data_file, "data/clean_data.csv", format = "file"),
  tar_target(data, load_data(data_file)),
  # impute missing data using mice
  tar_target(data_imputed, impute_data(data, m = 5)),
  # plot AI usage
  tar_target(plot_usage, plot_AI_usage(data)),
  
  #### Baseline intercept-only models ####
  
  # fit baseline models
  tar_map(
    values = tibble(
      outcome = c("trust", "reliable", "competent", "genuine", "ethical",
                  "autonomy", "potential_good", "potential_harm",
                  "interpretability", "explainability", "humanlike",
                  "predictability")
    ),
    tar_target(fit_baseline, fit_baseline_model(data, outcome)),
    tar_target(means_baseline, extract_means_baseline(fit_baseline, outcome))
  ),
  # plot differences from general AI
  tar_target(
    plot_diffs1,
    plot_mean_diffs_general_AI(
      list(
        means_baseline_trust,
        means_baseline_reliable,
        means_baseline_competent,
        means_baseline_genuine,
        means_baseline_ethical
      ),
      file = "plots/differences1.pdf"
    )
  ),
  tar_target(
    plot_diffs2,
    plot_mean_diffs_general_AI(
      list(
        means_baseline_trust,
        means_baseline_interpretability,
        means_baseline_explainability,
        means_baseline_predictability
      ),
      file = "plots/differences2.pdf"
    )
  ),
  tar_target(
    plot_diffs3,
    plot_mean_diffs_general_AI(
      list(
        means_baseline_trust,
        means_baseline_autonomy,
        means_baseline_humanlike,
        means_baseline_potential_good,
        means_baseline_potential_harm
      ),
      file = "plots/differences3.pdf",
      limits = c(-3.5, 3.5)
    )
  ),
  
  #### Fit regression models predicting trust ####
  
  # model 1 - performance and morality
  tar_target(
    fit_regression_model1,
    fit_regression_model(data_imputed, predictors = "performance + moral")
  ),
  tar_target(plot_reg_model1, plot_regression_model1(fit_regression_model1)),
  # model 2 - include moderators
  tar_map(
    values = list(
      moderator = c("autonomy", "potential_harm",
                    "interpretability", "humanlike")
    ),
    tar_target(
      fit_regression_model2,
      fit_regression_model(
        data_imputed,
        predictors = paste0(
          "performance + moral + ", moderator,
          " + performance*", moderator,
          " + moral*", moderator
        )
      )
    ),
    tar_target(
      plot_reg_model2,
      plot_regression_moderators(fit_regression_model2, moderator)
    )
  ),
  
  #### Session info ####
  
  # print session info for reproducibility
  tar_target(
    sessionInfo,
    writeLines(capture.output(sessionInfo()), "sessionInfo.txt")
  )
)
