# function to plot conditional effects for moderators
plot_regression_moderators <- function(fit, moderator) {
  # funtion to make plot
  make_plot <- function(effect) {
    # legend title
    legend <- str_replace(str_to_title(moderator), "_", "\n")
    # conditional effects plot
    cond <- 
      conditional_effects(
        x = fit,
        effects = paste0(effect, ":", moderator),
        int_conditions = setNames(list(c(-3, 0, 3)), moderator)
      )
    # plot
    plot(cond, plot = FALSE)[[1]] +
      scale_x_continuous(
        name = str_to_title(effect),
        breaks = -3:3,
        labels = function(x) x + 4
      ) +
      scale_y_continuous(
        name = "Trust",
        breaks = 1:7,
        limits = c(1, 7)
      ) +
      scale_colour_discrete(
        name = legend,
        labels = c("High (7)", "Medium (4)", "Low (1)")
      ) +
      scale_fill_discrete(
        name = legend,
        labels = c("High (7)", "Medium (4)", "Low (1)")
      ) +
      theme_bw() +
      theme(panel.grid = element_blank())
  }
  # make plots
  pA <- make_plot(effect = "performance")
  pB <- make_plot(effect = "moral")
  # put together
  out <- 
    pA + pB +
    plot_layout(
      guides = "collect",
      axes = "collect",
      axis_titles = "collect"
    )
  # save
  ggsave(
    file = paste0("plots/regression2_", moderator, ".pdf"),
    plot = out,
    height = 3,
    width = 6
  )
  return(out)
}
