# Data README file

**Dataset title:** Clean data for project on "Predictors of Trust in AI"

**Principal investigator:** Dr. Scott Claessens (scott.claessens@gmail.com)

**Head researcher:** Dr. Jim Everett (j.a.c.everett@kent.ac.uk)

**Institution:** University of Kent

**File format:** CSV file

**File dimensions:** 4800 rows x 28 columns

**Data collection platform:** Prolific

**Data collected on:** 24th July 2025

**Data collection country:** United Kingdom

**Columns in the dataset:**

- `id` - numeric, participant identification number
- `captcha` - numeric, Captcha score between 0 and 1
- `attention` - character, response to the attention check question. The
question was "When an important event is happening or is about to happen, many 
people try to get informed about the development of the situation. In such 
situations, where do you get your information from?" On the previous page,
participants are asked to respond to this question by saying "TikTok"
- `age` - numeric, participant's reported age in years
- `gender` - character, participant's self-reported gender identity
- `education` - numeric, 1-8, response to the question "What is the highest 
level of education you have completed?": (1) some primary school, (2) completed 
primary school, (3) some secondary school, (4) completed secondary school, (5) 
some university, (6) completed university, (7) some advanced study beyond 
university, (8) advanced degree beyond university
- `subjective_SES` - numeric, 1-10, response to the MacArthur Scale of 
Subjective Social Status, where 1 is the lowest rung on the ladder and 10 is the
highest rung on the ladder
- `political_ideology` - numeric, 1-7 Likert, response to the question "In 
political matters, people talk of 'the left' and 'the right'. Generally
speaking, how would you place your views on this scale?" ranging from Left (1) 
to Neutral (4) to Right (7)
- `religiosity` - numeric, 1-7 Likert, response to the question "How religious
are you?" ranging from Not At All Religious (1) to Somewhat Religious (4) to
Very Religious (7)
- `AI_familiarity` - numeric, 1-7 Likert, response to the question "Overall, how 
familiar are you with AI tools?" ranging from Not at All (1) to Very Much (7)
- `AI_frequency` - numeric, 1-5 Likert, response to the question "Overall, how 
frequently do you use AI tools?" with the following possible responses: (1) 
Never, (2) Rarely, (3) Occasionally, (4) Frequently, and (5) Very Frequently
- `generalised_trust` - numeric, 1-7 Likert, response to the question "Generally 
speaking, how much do you think that people can be trusted?" ranging from Not at
All (1) to Very Much (7)
- `block` - numeric, 1-6, order of the six blocks
- `type` - character, the type of AI presented to participants in each block
- `heard` - character, response to the question "Have you heard of [X] before?",
either Yes or No
- `used` - character, response to the question "Have you ever used [X]?", either
Yes or No
- `trust` - numeric, 1-7 Likert, response to the question "How much do you
think [X] can be trusted?" ranging from Not at All (1) to Very Much (7)
- `reliable` - numeric, 1-7 Likert, response to the question "How reliable do
you think [X] is?" ranging from Not at All (1) to Extremely (7)
- `competent` - numeric, 1-7 Likert, response to the question "How competent do
you think [X] is?" ranging from Not at All (1) to Extremely (7)
- `genuine` - numeric, 1-7 Likert, response to the question "How genuine do you
think [X] is?" ranging from Not at All (1) to Extremely (7)
- `ethical` - numeric, 1-7 Likert, response to the question "How ethical do you
think [X] is?" ranging from Not at All (1) to Extremely (7)
- `autonomy` - numeric, 1-7 Likert, response to the question "How much freedom
do you think [X] has in choosing how to behave?" ranging from None at All (1)
to Very Much (7)
- `potential_good` - numeric, 1-7 Likert, response to the question "How much do
you think [X] has a potential for good?" ranging from Not at All (1) to Very 
Much (7)
- `potential_harm` - numeric, 1-7 Likert, response to the question "How much do
you think [X] has a potential for harm?" ranging from Not at All (1) to Very 
Much (7)
- `interpetability` - numeric, 1-7 Likert, response to the question "When [X]
does something, how much do you think you could understand why it does that?"
ranging from Not at All (1) to Very Much (7)
- `explainability` - numeric, 1-7 Likert, response to the question "How much do
you think someone could explain the inner workings of [X]?" ranging from Not at
All (1) to Very Much (7)
- `humanlike` - numeric, 1-7 Likert, response to the question "How human-like do
you think [X] is?" ranging from Not at All (1) to Very Much (7)
- `predictability` - numeric, 1-7 Likert, response to the question "How much do
you think you could predict the behaviour of [X] in a new context?" ranging from
Not at All (1) to Very Much (7)
