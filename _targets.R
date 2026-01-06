library(targets)
library(tarchetypes)
library(tidyverse)

# load packages and scripts
tar_option_set(
  packages = c("brms", "future", "mice", "patchwork", "psych",
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
  # plot correlations for general AI
  tar_target(plot_cors, plot_correlations(data)),
  
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
    tar_target(means_baseline, extract_means_baseline(fit_baseline, outcome)),
    tar_target(post_baseline, posterior_samples(fit_baseline))
  ),
  # plot means
  tar_target(
    plot_means_baseline,
    plot_means(
      list(
        means_baseline_trust,
        means_baseline_reliable,
        means_baseline_competent,
        means_baseline_genuine,
        means_baseline_ethical,
        means_baseline_autonomy,
        means_baseline_potential_good,
        means_baseline_potential_harm,
        means_baseline_interpretability,
        means_baseline_explainability,
        means_baseline_humanlike,
        means_baseline_predictability
      )
    )
  ),
  # plot variation
  tar_target(
    plot_sd_baseline,
    plot_sd_pars(
      list(
        post_baseline_trust,
        post_baseline_reliable,
        post_baseline_competent,
        post_baseline_genuine,
        post_baseline_ethical,
        post_baseline_autonomy,
        post_baseline_potential_good,
        post_baseline_potential_harm,
        post_baseline_interpretability,
        post_baseline_explainability,
        post_baseline_humanlike,
        post_baseline_predictability
      )
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
      moderator = c("autonomy", "potential_harm", "interpretability", 
                    "humanlike", "predictability")
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
