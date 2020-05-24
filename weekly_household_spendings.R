# Weekly spending data
library(dplyr)
library(completejourney)

# Add week column
household_spendings <- read.csv("household_spendings.csv")
household_spendings$date <- as.Date(household_spendings$date,
                                    format = "%Y-%m-%d")

household_spendings <- household_spendings %>%
  mutate(week = cut.Date(date, breaks = "1 week", labels = FALSE))

household_spendings <- household_spendings[!(household_spendings$week==1 |
                                               household_spendings$week==54),]
household_spendings$week <- household_spendings$week - 1

# Remove date column, and group by weeks
household_spendings$date <- NULL
weekly_household_spendings <- household_spendings %>% group_by(household_id, week) %>% summarise(
  daily_amount_spent=sum(amount_spent)/7
)

write.csv(weekly_household_spendings,'weekly_household_spendings.csv', row.names=FALSE)
