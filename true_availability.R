# True availability of each coupon for each day for each household
# Previous table was lacking the fact that when coupon is used it is ended.
library(completejourney)
library(dplyr)

coupons_all<-inner_join(campaigns,campaign_descriptions)
coupons_all<-inner_join(coupons_all,coupons)
coupons_all<-left_join(coupons_all,coupon_redemptions)
coupons_all$end_date<-ifelse(!is.na(coupons_all$redemption_date)&(coupons_all$redemption_date<coupons_all$end_date),
                             coupons_all$redemption_date,
                             coupons_all$end_date)
coupons_all$end_date<-as.Date(coupons_all$end_date, origin="1970-01-01")
coupons_all$days<-as.numeric(difftime(coupons_all$end_date ,
                                      coupons_all$start_date,
                                      units = c("days")))
expanded <-coupons_all[rep(row.names(coupons_all), coupons_all$days), ]
coupons_all<-data.frame(expanded,date=expanded$start_date+(sequence(coupons_all$days)-1))
