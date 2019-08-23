library(tidyverse)
library(scales)

## Load data ##
experiment_summary <- read_csv("bancaja_experiment.csv")

# When analyzing the experiment results convert all of the experimental variables to a factor:

## Convert to Factor ##
# Method A
experiment_summary <- experiment_summary %>% mutate(
  waive_signing_fee = factor(waive_signing_fee),
  contingent_annual_fee = factor(contingent_annual_fee),
  interest_rate = factor(interest_rate),
  detailed_mailing = factor(detailed_mailing),
  send_plastic_card = factor(send_plastic_card),
  channel = factor(channel)
)

## Convert to Factor ##
# Method B
experiment_summary <- experiment_summary %>% mutate_at(
  vars(waive_signing_fee, contingent_annual_fee, interest_rate, detailed_mailing, send_plastic_card, channel),
  factor
)

## Run the regression analysis ##

model <- lm(
  "response_rate ~ waive_signing_fee + contingent_annual_fee + interest_rate + detailed_mailing + send_plastic_card + channel",
  data = experiment_summary
  )

summary(model)

## Calculating relative importance of different attributes
attribute_effects <- model$coefficients[-1]  # omit the first element: Intercept
importance <- percent(abs(attribute_effects) / sum(abs(attribute_effects)))
importance

# put the results in a table to better see the results
tibble(
  attribute = names(attribute_effects),
  importance = importance
)

## Predict the results for all of the possible combination of attributes

combinations <- read_csv("bancaja_combinations.csv")

# calculate the predicted response rate for all of the combinations
predict(model, combinations)

# lets add the predictions to the combinations
combinations <- combinations %>% 
  mutate(predicted_success = predict(model, combinations)) %>%
  arrange(desc(predicted_success))
write_csv(combinations, "bancaja_combinations.csv")
