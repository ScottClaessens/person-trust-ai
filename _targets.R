library(targets)
library(tarchetypes)

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
  # plot correlation matrix
  tar_target(plot_cor, plot_correlations(data)),
  # print session info for reproducibility
  tar_target(
    sessionInfo,
    writeLines(capture.output(sessionInfo()), "sessionInfo.txt")
  )
)
