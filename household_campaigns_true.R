## True availability of coupons for each household in each given date
library(completejourney)
library(dplyr)

# Expand so that we have information which coupon was available
# on each day for each household
coupons_all <- inner_join(campaigns, campaign_descriptions)
coupons <- coupons %>% filter(product_id %in% products)
coupons_all <- inner_join(coupons_all, coupons)
coupons_all <- left_join(coupons_all, coupon_redemptions)
coupons_all$end_date <- ifelse(!is.na(coupons_all$redemption_date) &
                                 (coupons_all$redemption_date <
                                    coupons_all$end_date),
                               coupons_all$redemption_date,
                               coupons_all$end_date)
coupons_all$end_date <- as.Date(coupons_all$end_date)
coupons_all$days <- as.numeric(difftime(coupons_all$end_date,
                                        coupons_all$start_date,
                                        units = c("days")))
expanded <- coupons_all[rep(row.names(coupons_all), coupons_all$days),]
coupons_all <- data.frame(expanded,date = expanded$start_date +
                            (sequence(coupons_all$days) - 1))
