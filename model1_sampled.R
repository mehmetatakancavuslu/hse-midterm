# Model 1 using the sampled data to overcome hardware limitations
#install required libraries
library(dplyr)
library(tidyverse) # Modern data science library
library(completejourney) # Retailer data
library(plm)       # Panel data analysis library
library(car)       # Companion to applied regression
library(gplots)    # Various programing tools for plotting data
library(tseries)   # For timeseries analysis
library(lmtest)
library(AER)
library(ggplot2)
library(GGally)
library(VGAM)

#Read CSVs
household_spendings <- read.csv("household_spendings.csv")
household_campaigns <-  read.csv("sampled_household_campaigns.csv")

#Merge to final dataset & removed unused DFs
m1 <- merge(household_campaigns,household_spendings)
rm("household_spendings","household_campaigns")

#Add total coupon count variable.

m1$coupon_count <- apply(m1[,c(3:29)], 1, sum)

# Since RAM memory not enough, simplify model by keeping only coupon count
m1 <- m1  %>% select(1,2,30,31)

#Change all variables to factors except amount spent for  OLS & Tobit
m1$date <- as.factor(m1$date)
m1$household_id <- as.factor(m1$household_id)
str(m1)

#tobit with VGAM Package
m_tobit2 <- vglm(amount_spent~household_id+date+coupon_count, tobit(Lower = 0), data = m1)
summary(m_tobit2)

