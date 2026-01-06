# function to plot means
plot_means <- function(list_means) {
  # get means for plot
  means <-
    bind_rows(list_means) |>
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
    means |> 
    filter(outcome == "Trust") |> 
    arrange(Estimate) |> 
    pull(type)
  # plot
  p <-
    ggplot() +
    # main colours
    geom_col(
      data = means,
      mapping = aes(
        y = Estimate - 1,
        x = fct_relevel(type, order)
      ),
      width = 0.1,
      colour = "grey90"
    ) +
    geom_point(
      data = means,
      mapping = aes(
        y = Estimate - 1,
        x = fct_relevel(type, order),
        colour = Estimate
      ),
      size = 1
    ) +
    # highlight general AI
    geom_col(
      data = filter(means, type == "General AI"),
      mapping = aes(
        y = Estimate - 1,
        x = fct_relevel(type, order)
      ),
      width = 0.1,
      colour = "#FFD3D3"
    ) +
    geom_point(
      data = filter(means, type == "General AI"),
      mapping = aes(
        y = Estimate - 1,
        x = fct_relevel(type, order)
      ),
      size = 1,
      colour = "red"
    ) +
    # other ggplot settings
    facet_wrap(
      . ~ outcome,
      nrow = 2,
      scales = "free_x"
    ) +
    scale_y_continuous(
      name = "Posterior mean rating",
      limits = c(0, 6),
      breaks = 0:6,
      labels = function(x) x + 1
    ) +
    scale_colour_viridis_c(limits = c(1, 7)) +
    xlab(NULL) +
    coord_flip() +
    theme_bw() +
    theme(
      panel.grid = element_blank(),
      strip.background = element_blank(),
      strip.text = element_text(size = 7),
      axis.title.x = element_text(size = 9),
      axis.text.x = element_text(size = 7),
      axis.text.y = element_text(
        size = 7,
        colour = ifelse(order == "General AI", "red", "black")
      ),
      legend.position = "none"
    )
  # save
  ggsave(
    file = "plots/means.pdf",
    plot = p,
    height = 5,
    width = 6
  )
  return(p)
}
