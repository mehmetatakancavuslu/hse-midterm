## The complete journet dataset warm-up and idea scrapbook
# install.packages("completejourney")
library(completejourney)
# Use "dplyr" to use filter function
library(dplyr)

## Example case study with John Smith -- household_id = 208
#------------------------------------------------------------------------
# Obtain demographic information from "demographics" table
john.id <- 208
str(demographics)
john.df <- demographics %>% filter(household_id == john.id)
# Check the campaigns he has received
john.campaigns <- campaigns %>% filter(household_id == john.id)
# Join with the campaign descriptions to get a better look
john.campaigns <- campaigns %>% filter(household_id == john.id) %>%
  left_join(., campaign_descriptions, by = "campaign_id")
# Arrange John's campaigns by date
john.campaigns %>% arrange(start_date)

