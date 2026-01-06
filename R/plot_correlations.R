# function to plot correlations
plot_correlations <- function(data, AI_type = "General AI") {
  # get upper triangle of correlation matrix
  cor_matrix <-
    data %>%
    filter(type == AI_type) %>%
    dplyr::select(trust:predictability) %>%
    cor(use = "pairwise")
  cor_matrix[lower.tri(cor_matrix)] <- NA
  diag(cor_matrix) <- NA
  # get p-value matrix (with bonferonni adjustment)
  p_matrix <-
    data %>%
    filter(type == AI_type) %>%
    dplyr::select(trust:predictability) %>%
    psych::corr.test(use = "pairwise", adjust = "bonferroni")
  p_matrix <- p_matrix$p
  p_matrix[lower.tri(p_matrix)] <- NA
  diag(p_matrix) <- NA
  # function to convert variable names
  convert_names <- function(x) {
    str_to_sentence(str_replace_all(x, "_", " "))
  }
  # wrangle data and plot
  cor <-
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
    )
  p_value <-
    p_matrix %>%
    as_tibble(rownames = "x") %>%
    pivot_longer(
      cols = !x,
      names_to = "y",
      values_to = "p"
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
    )
  d <-
    left_join(cor, p_value, by = c("x", "y")) %>%
    mutate(sig = p < 0.05)
  p <-
    ggplot() +
    geom_tile(
      data = d,
      mapping = aes(
        x = x,
        y = fct_rev(y),
        fill = cor
      )
    ) +
    geom_text(
      data = d,
      mapping = aes(
        x = x,
        y = fct_rev(y),
        label = format(round(cor, 2), nsmall = 2)
      ),
      size = 2) +
    geom_point(
      data = filter(d, !sig),
      mapping = aes(
        x = x,
        y = fct_rev(y)
      ),
      pch = 4,
      size = 5
    ) +
    scale_fill_gradient2(
      name = NULL,
      low = "blue",
      high = "red",
      limits = c(-1, 1)
    ) +
    labs(
      title = paste0("Correlations for ", AI_type),
      x = NULL,
      y = NULL
    ) +
    theme_bw() +
    theme(
      panel.border = element_blank(),
      axis.ticks = element_blank(),
      axis.text.x = element_text(angle = 35, hjust = 1, vjust = 1),
      plot.title = element_text(size = 12, hjust = 0.5, face = "bold"),
      legend.ticks = element_blank(),
      legend.text = element_text(size = 7),
      legend.key.size = unit(5, "mm")
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
      "plots/correlations_",
      convert_string(AI_type),
      ".pdf"
    ),
    height = 4,
    width = 5.3
  )
  return(p)
}
