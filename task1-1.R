library(dplyr)
df <- read.csv("household_campaigns.csv")

# Keep only non-zero rows, remove rows that contains only zeros
df_nonzeros <- df[rowSums(df[, 4:30])>0, ]

# This is how many coupon-days each household
df_couponcounts <- df_nonzeros %>% group_by(household_id) %>%
  summarise(coupon_count=n())

# Add also the other households with 0 coupon expose (which are removed before)
temp <- df %>% group_by(household_id) %>%
  summarise(temp=n())
full_couponcounts <- full_join(df_couponcounts, temp, by = "household_id")
full_couponcounts$temp <- NULL
full_couponcounts[is.na(full_couponcounts$coupon_count),]$coupon_count = 0
full_couponcounts <- full_couponcounts[order(full_couponcounts$household_id),]

# Write csv containing each household and how many days in the year they are
# exposed to a coupon campaign
write.csv(full_couponcounts,'couponcounts.csv', row.names=FALSE)

