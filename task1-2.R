#---------------------------Task 1-2

#install required libraries 
library(dplyr)
library(tidyverse)
library(completejourney)
library(arsenal)
library(coin)
#Read CSV with coupon counts created in Task 1-1
df <- read.csv("couponcounts.csv")

#Get all the demographic info 
demographics <- demographics


# Separate HS high exposed and low exposed 
df_low_exposed <- subset(df, coupon_count < 69)
df_high_exposed <- subset(df, coupon_count > 69)

# Create new df low exposed and high exposed  with demographics for analysis 
demo_low_exposed <- merge(df_low_exposed, demographics)
demo_high_exposed <-  merge(df_high_exposed, demographics)

summary(demo_low_exposed)
summary(demo_high_exposed)

# Create a new df for coupon counts distributed as High > 69 & Low < 69
#in order to analyze them together in a table. 
demo_all <-  merge(df, demographics)

demo_all <- demo_all %>%
  select(-household_id) %>%
  mutate(coupon_count = ifelse(coupon_count > 69, "high", "low")) %>%
  mutate(coupon_count = factor(coupon_count))

# Create Summary statistics table 
table_one <- tableby(coupon_count ~ ., data = demo_all,results="asis")
summary(table_one, title = "Demographic Data for High and Low exposure HH",
        text=TRUE)



# Write csv containing high and low exposed households with demographics. 
# an for all counts demographics divided into high and low only. 
write.csv(demo_low_exposed,'demo_low_exposed.csv', row.names=FALSE)
write.csv(demo_high_exposed,'demo_high_exposed.csv', row.names=FALSE)
write.csv(demo_all,'demo_all.csv', row.names=FALSE)

