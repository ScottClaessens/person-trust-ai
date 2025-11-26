# function to plot standard deviation parameters
plot_sd_pars <- function(list_post) {
  # get names of measures
  measures <- c("Trust", "Reliable", "Competent", "Genuine", "Ethical",
                "Autonomy", "Potential good", "Potential harm", 
                "Interpretability", "Explainability", "Humanlike", 
                "Predictability")
  # loop over list
  p <- 
    bind_rows(
      lapply(
        seq_along(list_post),
        function(i) {
          tibble(
            resp = measures[i],
            sd_type__Intercept = list_post[[i]]$sd_type__Intercept
          )
        }
      )
    ) |>
    mutate(resp = factor(resp, levels = measures)) |>
    # plot
    ggplot(
      aes(
        x = sd_type__Intercept,
        y = fct_rev(resp)
      )
    ) +
    stat_dist_slabinterval() +
    scale_x_continuous(
      name = "Posterior standard deviation across AI systems",
      limits = c(0, 3)
    ) +
    ylab(NULL) +
    theme_classic()
  # save
  ggsave(
    plot = p,
    file = "plots/variation.pdf",
    height = 3,
    width = 5
  )
  return(p)
}
