# function to plot slopes from regression model 1
plot_regression_model1 <- function(fit) {
  # fixed effects
  f <- fixef(fit, summary = FALSE)
  # random effects
  r <- ranef(fit, summary = FALSE)
  # titles for plot
  titles <- c(
    "slope_performance" = "Effect of performance\non trust",
    "slope_moral" = "Effect of morality\non trust",
    "difference" = "Difference in effects\n(performance - morality)"
  )
  # create plot
  p <- 
    # get in tibble
    tibble(
      type               = c(colnames(r$type)),
      fixed_performance  = list(as.vector(f[, "performance"])),
      fixed_moral        = list(as.vector(f[, "moral"])),
      random_performance = c(lapply(1:21, \(i) r$type[, i, "performance"])),
      random_moral       = c(lapply(1:21, \(i) r$type[, i, "moral"]))
    ) |>
    # calculate slopes and differences
    rowwise() |>
    mutate(
      slope_performance = list(fixed_performance + random_performance),
      slope_moral       = list(fixed_moral + random_moral),
      difference        = list(slope_performance - slope_moral)
    ) |>
    select(!c(fixed_performance, fixed_moral, 
              random_performance, random_moral)) |>
    # pivot longer for plotting
    pivot_longer(
      cols = slope_performance:difference,
      names_to = "parameter",
      values_to = "post"
    ) |>
    unnest(c(post)) |>
    mutate(parameter = factor(titles[parameter], levels = titles)) |>
    # order y-axis
    mutate(
      type = factor(
        type,
        levels = c(
          "Robot vacuum", "Google Maps AI", "Audio transcription AI",
          "Apple's Siri", "Air traffic control AI", "Facial recognition AI",
          "ChatGPT", "Skin cancer diagnosis app", "DALL-E", "Medical triage AI",
          "Military cybersecurity AI", "Instagram filter", "AI therapist",
          "Predictive policing algorithm", "Self-driving car",
          "Predictive sentencing algorithm", "DeepSeek", "Robot soldier",
          "AI superintelligence", "Autonomous killer drone", "General AI"
        )
      )
    ) |>
    # plot
    ggplot(
      aes(
        x = post,
        y = fct_rev(type),
        fill = as.character(type) == "General AI"
      )
    ) +
    stat_dist_slabinterval() +
    geom_vline(
      xintercept = 0,
      linetype = "dashed"
    ) +
    facet_wrap(
      . ~ parameter,
      scales = "free_x",
      strip.position = "bottom"
    ) +
    xlab(NULL) +
    ylab(NULL) +
    scale_fill_manual(values = c("lightgrey", "#FF6961")) +
    theme_bw() +
    theme(
      legend.position = "none",
      axis.text.y = element_text(colour = c("red", rep("black", 21))),
      strip.placement = "outside",
      strip.background = element_blank(),
      strip.text = element_text(size = 11, vjust = 1),
      panel.grid = element_blank()
    )
  # save
  ggsave(
    file = "plots/regression1.pdf",
    plot = p,
    width = 7.5,
    height = 5
  )
  return(p)
}
