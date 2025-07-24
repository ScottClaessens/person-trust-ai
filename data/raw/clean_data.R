# Clean raw dataset

library(qualtRics) # v3.2.1
library(tidyverse) # v2.0.0

# vector of AI types and full names
types <- c(
  "GeneralAI"  = "General AI",
  "AirTraffic" = "Air traffic control AI",
  "Audio"      = "Audio transcription AI",
  "Car"        = "Self-driving car",
  "ChatGPT"    = "ChatGPT",
  "DALLE"      = "DALL-E",
  "DeepSeek"   = "DeepSeek",
  "Drone"      = "Autonomous killer drone",
  "FacialRec"  = "Facial recognition AI",
  "Instagram"  = "Instagram filter",
  "Maps"       = "Google Maps AI",
  "Medical"    = "Medical triage AI",
  "Military"   = "Military cybersecurity AI",
  "Policing"   = "Predictive policing algorithm",
  "Sentencing" = "Predictive sentencing algorithm",
  "Siri"       = "Apple's Siri",
  "SkinCancer" = "Skin cancer diagnosis app",
  "Soldier"    = "Robot soldier",
  "SuperAI"    = "AI superintelligence",
  "Therapist"  = "AI therapist",
  "Vacuum"     = "Robot vacuum"
)

# attention codes
attention_codes <- c("TV", "Twitter", "Radio", "Facebook", "YouTube",
                     "Newspapers", "Reddit", "TikTok", "Other")

# gender codes
gender_codes <- c("Male", "Female", "Non-binary / third gender",
                  "Prefer to self-describe", "Prefer not to say")

# load raw data
read_survey(
  file_name = "Predictors+of+Trust+in+AI_July+24,+2025_12.12.csv",
  add_var_labels = FALSE
) |>
  # add id column
  rowid_to_column("id") |>
  # keep relevant columns
  dplyr::select(id, Q_RecaptchaScore, Attention:Religious, AIType1:AIType5) |>
  # amend gender identity for one case
  mutate(Gender = ifelse(!is.na(Gender_4_TEXT), 2, Gender)) |>
  dplyr::select(!Gender_4_TEXT) |>
  # pivot longer
  pivot_longer(
    cols = contains("_") & !any_of(
      c("Q_RecaptchaScore", "AI_Familiarity", "AI_Frequency", "Gender_4_TEXT")
    ),
    names_to = c("variable", "type"),
    names_pattern = "(.*)_(.*)",
    values_to = "value"
  ) |>
  # pivot wider
  pivot_wider(
    names_from = "variable",
    values_from = "value"
  ) |>
  # get full AI names and block number
  mutate(
    type = types[type],
    block = ifelse(type == "General AI", 1, NA),
    block = ifelse(type == AIType1, 2, block),
    block = ifelse(type == AIType2, 3, block),
    block = ifelse(type == AIType3, 4, block),
    block = ifelse(type == AIType4, 5, block),
    block = ifelse(type == AIType5, 6, block)
  ) |>
  drop_na(block) |>
  arrange(id, block) |>
  # rename columns
  transmute(
    id                 = id,
    captcha            = round(Q_RecaptchaScore, 2),
    attention          = attention_codes[Attention],
    age                = Age,
    gender             = gender_codes[Gender],
    education          = Education,
    subjective_SES     = SES,
    political_ideology = PoliticalIdeology,
    religiosity        = Religious,
    AI_familiarity     = AI_Familiarity,
    AI_frequency       = AI_Frequency,
    generalised_trust  = GeneralisedTrust,
    block              = block,
    type               = type,
    heard              = c("No", "Yes")[Heard],
    used               = c("No", "Yes")[Used],
    trust              = Trust,
    reliable           = Reliable,
    competent          = Competent,
    genuine            = Genuine,
    ethical            = Ethical,
    autonomy           = Autonomy,
    potential_good     = Good,
    potential_harm     = Harm,
    interpretability   = Interpret,
    explainability     = Explain,
    humanlike          = Humanlike,
    predictability     = Predict
  ) |>
  # write to csv
  write_csv(file = "clean_data.csv")
