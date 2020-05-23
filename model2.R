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
household_campaigns <-  read.csv("household_campaigns.csv")
household_campaigns <- household_campaigns[,-1]

#Merge to final dataset & removed unused DFs
m1 <- merge(household_campaigns,household_spendings)
rm("household_spendings","household_campaigns")

#Add total coupon count variable.

m1$coupon_count <- apply(m1[,c(3:29)], 1, sum)

# Since RAM memory not enough, simplify model by keeping only coupon count
m1 <- m1  %>% select(1,2,30,31)


#Change all variables to factors except amount spent for  OLS & Tobit
m1[1,2] <- lapply(m1[1,2], factor)
m1$amount_spent <- as.numeric(m1$amount_spent)
str(m1)
#Exploratory data analysis

scatterplot(amount_spent ~ date|household_id, data=m1)
plotmeans(amount_spent ~ date, data = m1)

#Basic OLS Model
m_ols <-lm(amount_spent~household_id+date+coupon_count
           , data = m1)
summary(m_ols)

#Try visualization

Vis <- m_ols$fitted
ggplot(m1, aes(x = coupon_count, y = amount_spent))+
  geom_point() +
  geom_smooth(method=lm)

#Tobit with first option (Package AER)

m_tobit1 <- tobit(amount_spent~household_id+date+coupon_count, data = m1)
summary(m_tobit1)


#tobit with second option  (VGAM Package )

m_tobit2 <- vglm(amount_spent~household_id+date+coupon_count, tobit(Upper = Inf), data = m1)
summary(m_tobit2)


