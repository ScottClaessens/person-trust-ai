# function to plot histograms for specific AI type
plot_histograms <- function(data, AI_type = "General AI") {
  # function to convert variable names
  convert_var_name <- function(x) {
    str_to_sentence(str_replace_all(x, "_", " "))
  }
  # plot
  p <-
    data %>%
    filter(type == AI_type) %>%
    pivot_longer(
      cols = trust:predictability,
      names_to = "variable"
    ) %>%
    mutate(
      variable = convert_var_name(variable),
      variable = factor(
        variable,
        levels = convert_var_name(colnames(data)[15:26])
      )
    ) %>%
    ggplot(aes(x = value)) +
    geom_bar() +
    facet_wrap(. ~ variable) +
    scale_x_continuous(
      name = NULL,
      breaks = 1:7
    ) +
    ylab("Count") +
    ggtitle(paste0("Histograms for '", AI_type, "'")) +
    theme_classic() +
    theme(
      strip.background = element_blank(),
      axis.line.x = element_blank(),
      axis.ticks.x = element_blank()
    )
  # lower case AI type name for file saving
  convert_string <- function(x) {
    x <- str_replace_all(x, " ", "_")
    x <- str_replace_all(x, "-", "_")
    x <- str_replace_all(x, "'", "")
    x <- str_to_lower(x)
    x <- str_replace_all(x, "ai", "AI")
    x <- str_replace_all(x, "AIr", "air")
    str_replace_all(x, "dall_e", "dalle")
  }
  # save and return
  ggsave(
    plot = p,
    file = paste0(
      "plots/histograms/histograms_",
      convert_string(AI_type),
      ".pdf"
    ),
    height = 4,
    width = 5.5
  )
  return(p)
}
