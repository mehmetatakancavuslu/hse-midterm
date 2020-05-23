# Model2
library(completejourney)
library(dplyr)

household_campaign_types <- read.csv("household_campaign_types.csv")
household_spendings <- read.csv("household_spendings.csv")

model2_df <- merge(household_campaign_types, household_spendings,
                   by=c("household_id","date"), all=T)

model2_df$household_id <- as.factor(model2_df$household_id)
rm(household_campaign_types, household_spendings)

model2_df$date <- as.factor(model2_df$date)
model2_df$household_id <- as.factor(model2_df$household_id)


