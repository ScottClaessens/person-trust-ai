# function to plot rankings with random intercepts from model 0
plot_model0 <- function(data, fit0, outcome = "trust") {
  # extract model predictions
  newdata <- tibble(
    type = c(
      "General AI", "Autonomous killer drone",
      "Predictive sentencing algorithm", "Instagram filter", 
      "Self-driving car", "ChatGPT", "DALL-E", "AI superintelligence", 
      "Predictive policing algorithm", "Apple's Siri", "AI therapist",
      "Skin cancer diagnosis app", "Military cybersecurity AI",
      "Air traffic control AI", "Google Maps AI", "Audio transcription AI", 
      "Robot vacuum", "DeepSeek", "Robot soldier", "Facial recognition AI",
      "Medical triage AI"
    )
  )
  f <- fitted(
    object = fit0,
    newdata = newdata,
    re_formula = ~ (1 | type),
    summary = FALSE
  )
  # calculate posterior means
  post <- matrix(0, nrow = nrow(f), ncol = ncol(f))
  for (i in 1:7) post <- post + (f[, , i] * i)
  # add posterior means to data
  newdata <-
    newdata %>%
    mutate(
      post = lapply(seq_len(ncol(post)), function(i) as.numeric(post[,i]))
    )
  # outcome text for plot
  outcome_text <- str_to_sentence(str_replace(outcome, "_", " "))
  # rearrange data for plot
  data <-
    data %>%
    group_by(type) %>% 
    summarise(mean = mean(!!sym(outcome), na.rm = TRUE) - 1) %>%
    mutate(General = type == "General AI")
  # plot
  p <-
    newdata %>%
    unnest(post) %>%
    mutate(General = type == "General AI") %>%
    ggplot() +
    geom_col(
      data = data,
      mapping = aes(
        x = type,
        y = mean,
        fill = General
      )
    ) +
    tidybayes::stat_pointinterval(
      mapping = aes(
        x = fct_reorder(type, post),
        y = post - 1,
        colour = General
      ),
      size = 2
    ) +
    scale_y_continuous(
      limits = c(0, 6),
      breaks = 0:6,
      labels = 1:7,
      expand = expansion(mult = c(0, 0))
    ) +
    scale_colour_manual(values = c("black", "red")) +
    scale_fill_manual(values = c("#cbe7ef", "#efd3cb")) +
    labs(
      title = paste0(outcome_text, " ratings across AI types"),
      subtitle = "Sample means (bars) and model predictions (point intervals)",
      x = NULL,
      y = outcome_text
    ) +
    coord_flip() +
    theme_classic() +
    theme(
      axis.text.y = element_text(
        size = 8,
        # vectorised colour from posterior median rankings
        colour = newdata %>%
          unnest(post) %>%
          group_by(type) %>%
          summarise(post = median(post)) %>%
          arrange(post) %>%
          mutate(colour = ifelse(type == "General AI", "red", "black")) %>%
          pull(colour)
      ),
      axis.text.x = element_text(size = 8),
      plot.title = element_text(size = 12),
      plot.subtitle = element_text(size = 8),
      legend.position = "none"
    )
  # save and return
  ggsave(
    plot = p,
    file = paste0("plots/model0/ranking_", outcome, ".pdf"),
    height = 4,
    width = 5
  )
  return(p)
}
