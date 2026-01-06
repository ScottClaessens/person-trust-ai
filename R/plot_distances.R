# function to plot distances from general AI
plot_distances <- function(list_means) {
  # get model-estimated means
  d <-
    bind_rows(list_means) |>
    dplyr::select(!c(Estimate, `2.5%`, `97.5%`)) |>
    pivot_wider(
      names_from = type,
      values_from = post
    ) |>
    # for each AI system, calculate absolute differences from general AI
    rowwise() |>
    mutate(
      across(
        `Autonomous killer drone`:`Medical triage AI`,
        function(x) list(abs(`General AI` - x)) # absolute difference
      )
    ) |>
    ungroup() |>
    dplyr::select(!`General AI`) |>
    # transpose and sum across outcomes
    pivot_longer(cols = !outcome) |>
    pivot_wider(
      names_from = outcome,
      values_from = value
    ) |>
    rowwise() |>
    transmute(
      Type = name,
      # all variables
      `All measures` = list(
        (trust + reliable + competent + genuine + ethical + autonomy + 
          potential_good + potential_harm + interpretability + explainability +
          humanlike + predictability) / (6 * 12)
      ),
      # trust only
      Trust = list(trust / 6),
      # performance only
      Performance = list((reliable + competent) / 12),
      # morality only
      Morality = list((genuine + ethical) / 12)
    ) |>
    pivot_longer(
      cols = !Type,
      names_to = "Composite"
    ) |>
    # calculate median and 95% CIs
    rowwise() |>
    mutate(
      Estimate = median(value),
      `Q2.5` = quantile(value, 0.025),
      `Q97.5` = quantile(value, 0.975)
    ) |>
    select(!value) |>
    mutate(
      Composite = factor(
        Composite, levels = c(
          "All measures", "Trust", "Performance", "Morality"
        )
      )
    )
  # get order for plot
  order <-
    d |>
    filter(Composite == "All measures") |>
    arrange(Estimate) |>
    pull(Type)
  # plot
  p <-
    ggplot(
      data = d,
      mapping = aes(
        x = fct_relevel(Type, rev(order)),
        y = Estimate,
        ymin = `Q2.5`,
        ymax = `Q97.5`,
        fill = Composite
      )
    ) +
    geom_col(position = "dodge") +
    geom_pointrange(size = 0.1) +
    coord_flip() +
    facet_wrap(
      . ~ Composite,
      nrow = 1
    ) +
    labs(
      x = NULL,
      y = "Distance from General AI"
    ) +
    theme_bw() +
    theme(
      legend.position = "none",
      panel.grid = element_blank(),
      panel.border = element_blank(),
      axis.line.x = element_line(),
      axis.text.x = element_text(size = 7.5),
      axis.title.x = element_text(size = 10),
      axis.ticks.y = element_blank(),
      strip.background = element_blank(),
      strip.text = element_text(face = "bold")
    )
  # save
  ggsave(
    plot = p,
    file = "plots/distances.pdf",
    width = 6.5,
    height = 3.5
  )
  return(p)
}
