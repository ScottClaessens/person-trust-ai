# function to plot random slopes from model 1
plot_model1 <- function(fit1, predictor = "reliable") {
  # extract fixed and random effects
  p <-
    fit1 %>%
    spread_draws(
      # fixed effect
      !!sym(paste0("b_", predictor)),
      # random effect
      r_type[type, parameter]
    ) %>%
    filter(parameter != "Intercept") %>%
    # add "overall" rows for plotting
    bind_rows(
      spread_draws(
        fit1, 
        !!sym(paste0("b_", predictor))
      ) %>%
        mutate(
          type = "Overall",
          r_type = 0
        )
    ) %>%
    mutate(
      # combine fixed and random effects
      slope = !!sym(paste0("b_", predictor)) + r_type,
      # rename types
      type = str_replace_all(type, fixed("."), " "),
      type = factor(type, levels = c(sort(unique(fit1$data$type)), "Overall"))
    ) %>%
    # plot
    ggplot(
      aes(
        x = slope,
        y = fct_rev(type),
        fill = as.character(type) == "Overall"
      )
    ) +
    stat_dist_slabinterval() +
    geom_vline(
      xintercept = 0,
      linetype = "dashed"
    ) +
    ggtitle(
      paste0("Effect of '", str_replace(predictor, "_", " "), "' on trust")
    ) +
    scale_x_continuous(
      name = "Estimate",
      limits = if (predictor == "potential_harm") {
        c(-2.5, 0.1) 
      } else {
        c(-0.1, 2.5)
      } 
    ) +
    ylab(NULL) +
    scale_fill_manual(values = c("lightgrey", "#FF6961")) +
    theme_classic() +
    theme(
      legend.position = "none",
      axis.text.y = element_text(
        colour = c("red", rep("black", 21))
      )
    )
  # save and return
  ggsave(
    plot = p,
    file = paste0("plots/model1/slopes_", predictor, ".pdf"),
    height = 5,
    width = 6
  )
  return(p)
}
