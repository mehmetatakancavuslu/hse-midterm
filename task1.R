library(dplyr)
df <- read.csv("household_campaigns.csv")

df_nonzeros <- df[rowSums(df[, 4:30])>0, ]

df_couponcounts <- df_nonzeros %>% group_by(household_id) %>%
  summarise(coupon_count=n())
