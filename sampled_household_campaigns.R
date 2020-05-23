library(dplyr)
library(completejourney)

# Create a random vector for households consisting ids between 1 and 2499 with
# 1250 elements, practically randomly sampling 50%
set.seed(555)
sample_vector <- sample.int(2499, 1250)

# Filter the original data
household_campaigns <- read.csv("household_campaigns.csv")
household_campaigns <- household_campaigns[,-1]
household_campaigns %>% filter(household_id %in% vc)
