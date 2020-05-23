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


#Read CSVs
household_spendings <- read.csv("household_spendings.csv")
household_campaigns <-  read.csv("household_campaigns.csv")
household_campaigns <- household_campaigns[,-1]

#Merge to final dataset
m1 <- merge(household_campaigns,household_spendings)
rm("household_spendings","household_campaigns")

#Change all variables to factors except amount spent
m1[1:29] <- lapply(m1[1:29], factor)
m1$amount_spent <- as.numeric(m1$amount_spent)
str(m1)

#Exploratory data analysis
scatterplot(amount_spent ~ date|household_id, data=m1)
# Heterogenity between households
plotmeans(amount_spent ~ household_id, data = m1)
# Heterogenity between days
plotmeans(amount_spent ~ date, data = m1)


#Basic OLS Model
m_ols <-lm(amount_spent~household_id+date+X1+X2+X3+X4+X5+X6+X7+X8+X9+X10+X11+X12+
             X13+X14+X15+X16+X17+X18+X19+X20+X21+X22+X23+X24+X25+X26+X27
           , data = m1)
summary(ols)

#Tobit

m_tobit <- tobit(amount_spent~household_id+date+X1+X2+X3+X4+X5+X6+X7+X8+X9+X10+X11+X12+
          X13+X14+X15+X16+X17+X18+X19+X20+X21+X22+X23+X24+X25+X26+X27, data = m1)
