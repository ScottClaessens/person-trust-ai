# function to plot correlation matrix based on general AI questions
plot_correlations <- function(data) {
  # get upper triangle of correlation matrix
  cor_matrix <-
    data %>%
    filter(type == "General AI") %>%
    dplyr::select(trust:predictability) %>%
    cor()
  cor_matrix[lower.tri(cor_matrix)] <- NA
  diag(cor_matrix) <- NA
  # function to convert variable names
  convert_names <- function(x) {
    str_to_sentence(str_replace_all(x, "_", " "))
  }
  # wrangle data and plot
  p <-
    cor_matrix %>%
    as_tibble(rownames = "x") %>%
    pivot_longer(
      cols = !x,
      names_to = "y",
      values_to = "cor"
    ) %>%
    drop_na() %>%
    mutate(
      across(
        c(x, y),
        function(x) {
          factor(
            convert_names(x),
            levels = convert_names(rownames(cor_matrix))
          )
        }
      )
    ) %>%
    ggplot(aes(x, fct_rev(y), fill = cor)) +
    geom_tile() +
    scale_fill_gradient2(
      name = NULL,
      low = "blue",
      high = "red",
      limits = c(-1, 1)
    ) +
    labs(
      title = "Correlations for 'General AI'",
      x = NULL,
      y = NULL
    ) +
    theme_bw() +
    theme(
      panel.border = element_blank(),
      axis.ticks = element_blank(),
      axis.text.x = element_text(angle = 35, hjust = 1, vjust = 1),
      legend.ticks = element_blank() 
    )
  # save and return
  ggsave(
    plot = p,
    file = "plots/correlations.pdf",
    height = 4,
    width = 5.3
  )
}
