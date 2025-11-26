# function to plot differences in means from general AI
plot_mean_diffs_general_AI <- function(list_means) {
  # function to get difference from general AI
  convert_means_to_diffs <- function(means) {
    # get general AI mean
    general_AI_mean <- unlist(means$post[means$type == "General AI"])
    # convert
    means |>
      # remove general AI
      filter(type != "General AI") |>
      select(!c(Estimate, `2.5%`, `97.5%`)) |>
      # calculate mean differences
      rowwise() |>
      mutate(post = list(post - general_AI_mean)) |>
      # summarise
      group_by(outcome, type) |>
      rowwise() |>
      summarise(
        Estimate = median(post),
        `2.5%` = quantile(post, 0.025),
        `97.5%` = quantile(post, 0.975),
        .groups = "drop"
      )
  }
  # get differences for plot
  diffs <-
    bind_rows(lapply(list_means, convert_means_to_diffs)) |>
    mutate(
      outcome = factor(
        str_to_sentence(str_replace(outcome, "_", " ")),
        levels = c("Trust", "Reliable", "Competent", "Genuine", "Ethical",
                   "Autonomy", "Potential good", "Potential harm", 
                   "Interpretability", "Explainability", "Humanlike", 
                   "Predictability")
      )
    )
  # get order for plot
  order <-
    diffs |> 
    filter(outcome == "Trust") |> 
    arrange(Estimate) |> 
    pull(type)
  # plot
  p <-
    ggplot(
      data = diffs,
      mapping = aes(
        x = Estimate,
        xmin = `2.5%`,
        xmax = `97.5%`,
        y = fct_relevel(type, order)
      )
    ) +
    geom_vline(
      xintercept = 0,
      linetype = "dashed",
      size = 0.3
    ) +
    geom_pointrange(
      fatten = 0.4,
      size = 1
    ) +
    facet_wrap(. ~ outcome, nrow = 2) +
    scale_x_continuous(
      name = "Posterior mean difference from 'General AI'",
      limits = c(-3, 3)
    ) +
    ylab(NULL) +
    theme_bw() +
    theme(
      panel.grid = element_blank(),
      strip.background = element_blank(),
      strip.text = element_text(size = 7),
      axis.text.x = element_text(size = 7),
      axis.text.y = element_text(size = 7)
    )
  # save
  ggsave(
    file = "plots/differences.pdf",
    plot = p,
    height = 5,
    width = 6
  )
  return(p)
}
