library(tidyverse)
library(DoE.base)

# simple example
combinations <- expand.grid(signing_fee = c("charged", "waved"), send_card = c("no", "yes"))

# Create all possible combination of attributes in the Bancaja case study
# If we include all 64 possible combination in the expeiment, it is called Full Factorial design
combinations <- expand.grid(
  waive_signing_fee = c("Yes", "No"),
  contingent_annual_fee = c("Yes", "No"),
  interest_rate = c("15%", "12%"),
  detailed_mailing = c("Yes", "No"),
  send_plastic_card = c("Yes", "No"),
  channel = c("Mail", "Branch")
)

write_csv(combinations, "bancaja_combinations.csv")

# Orthogonal (Fractional Factorila) design 
orthogonal_design <- oa.design(factor.names = list(
  waive_signing_fee = c("Yes", "No"),
  contingent_annual_fee = c("Yes", "No"),
  interest_rate = c("15%", "12%"),
  detailed_mailing = c("Yes", "No"),
  send_plastic_card = c("Yes", "No"),
  channel = c("Mail", "Branch")
))

# Sort the result to make it easy to compare with the charts in the case study
orthogonal_design <- orthogonal_design %>% arrange(waive_signing_fee,
                                                   desc(contingent_annual_fee),
                                                   interest_rate)

write_csv(orthogonal_design, "bancaja_orthogonal_design.csv")

