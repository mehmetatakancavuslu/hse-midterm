# Weekly data
library(dplyr)
library(completejourney)

# Add week column
household_campaigns <- read.csv("household_campaigns.csv")
household_campaigns$X <- NULL
household_campaigns$coupon_count <- apply(household_campaigns[,c(3:29)], 1, sum)
household_campaigns <- household_campaigns  %>% select(1,2,30)
household_campaigns$date <- as.Date(household_campaigns$date,
                                    format = "%Y-%m-%d")

household_campaigns <- household_campaigns %>%
  mutate(week = cut.Date(date, breaks = "1 week", labels = FALSE))

household_campaigns <- household_campaigns[!(household_campaigns$week==1 |
                                               household_campaigns$week==54),]
household_campaigns$week <- household_campaigns$week - 1

# Remove date column, and group by weeks
household_campaigns$date <- NULL
weekly_household_campaigns <- household_campaigns %>% group_by(household_id, week) %>% summarise(
  coupons_per_day=sum(coupon_count)/7
)

write.csv(weekly_household_campaigns,'weekly_household_campaigns.csv', row.names=FALSE)
