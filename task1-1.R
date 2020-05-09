library(dplyr)
df <- read.csv("household_campaigns.csv")

# Keep only non-zero rows, remove rows that contains only zeros
df_nonzeros <- df[rowSums(df[, 4:30])>0, ]

# This is how many coupon-days each household
df_couponcounts <- df_nonzeros %>% group_by(household_id) %>%
  summarise(coupon_count=sum(X1, X2, X3, X4, X5, X6, X7, X8, X9, X10, X11, X12,
                             X13, X14, X15, X16, X17, X18, X19, X20, X21, X22,
                             X23, X24, X25, X26, X27))

# Add also the other households with 0 coupon expose
temp <- df %>% group_by(household_id) %>%
  summarise(temp=n())
full_couponcounts <- full_join(df_couponcounts, temp, by = "household_id")
full_couponcounts$temp <- NULL
full_couponcounts[is.na(full_couponcounts$coupon_count),]$coupon_count = 0
full_couponcounts <- full_couponcounts[order(full_couponcounts$household_id),]

# Write csv containing each household and how many days in the year they are
# exposed to a coupon campaign
write.csv(full_couponcounts,'couponcounts.csv', row.names=FALSE)

