# function to plot usage of different AI types
plot_AI_usage <- function(data) {
  # plot
  p <-
    data |>
    filter(type != "General AI") |>
    group_by(type) |>
    summarise(
      prop_heard = mean(heard == "Yes", na.rm = TRUE),
      prop_used  = mean(used == "Yes", na.rm = TRUE)
    ) |>
    ggplot(aes(x = fct_reorder(type, prop_heard))) +
    geom_col(aes(y = prop_heard), fill = "skyblue") +
    geom_col(aes(y = prop_used), fill = "skyblue4") +
    scale_y_continuous(expand = c(0, 0.02), limits = c(0, 1)) +
    coord_flip() +
    labs(
      x = NULL,
      y = paste0(
        "Proportion who have heard of (light blue)\n",
        "and used (dark blue) AI system"
      )
    ) +
    theme_minimal() +
    theme(panel.grid = element_blank())
  # save
  ggsave(
    plot = p,
    file = "plots/AI_usage.pdf",
    width = 6,
    height = 4
  )
  return(p)
}
