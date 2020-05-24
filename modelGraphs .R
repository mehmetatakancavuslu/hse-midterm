#---------------------------Model 1

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

#--------------- M1 --- Sampled DATA with only 50% of observations
#for the regression and tobit due to low ram capacity. 

#Read CSVs M1
household_spendings <- read.csv("household_spendings.csv")
household_campaigns <-  read.csv("sampled_household_campaigns.csv")

#Merge to final dataset & removed unused DFs
m1 <- merge(household_campaigns,household_spendings)
demo_all <- merge(m2,demographics)
rm("household_spendings","household_campaigns")


#Add total coupon count variable. 

m1$coupon_count <- apply(m1[,c(3:29)], 1, sum)

# Since RAM memory not enough, simplify model by keeping only coupon count 
m1 <- m1  %>% select(1,2,30,31)


#Change all variables to factors except amount spent for  OLS & Tobit 
m1[1:2] <- lapply(m1[1:2], factor)
m1$amount_spent <- as.numeric(m1$amount_spent)
str(m1)

#--------------- M2 ----- full observations used to merge with demographics and
#other variables to make graphs 

#Red CSVs M2
household_spendings1 <- read.csv("household_spendings.csv")
household_campaigns1 <-  read.csv("household_campaigns.csv")
household_campaigns1 <- household_campaigns[,-1]
coupon_total_counts <- setNames(read.csv("couponcounts2.csv"),
                                c("household_id","total_coupons")) 

rm(coupon_counts)

#Merge to final dataset & removed unused DFs
m2 <- merge(household_campaigns1,household_spendings1)
rm("household_spendings1","household_campaigns1")

#Add total coupon count variable. 

m2$coupon_count <- apply(m2[,c(3:29)], 1, sum)

# Since RAM memory not enough, simplify model by keeping only coupon count 
m2 <- m2  %>% select(1,2,30,31)

#Change all variables to factors except amount spent for  OLS & Tobit 
m2[1:2] <- lapply(m2[1:2], factor)
m2$amount_spent <- as.numeric(m2$amount_spent)
str(m2)

#-----------------------------------

#Get demographics info 

demographics <- demographics

coupon_red <- coupon_redemptions

#aggregating data to do demographic visualizations

m1_agg <- setNames(aggregate(m2$amount_spent,
                             by=list(household_id=m2$household_id), FUN=sum),
                   c("household_id","total_spent"))

demo_all_agg <- merge(demo_all,m1_agg)

# Remove duplicates based on Household ID
demo_all_agg <- demo_all_agg[!duplicated(demo_all_agg$household_id), ]

# remove amount spent column to leave only total spent 
demo_all_agg <- demo_all_agg[,-3]

#Adding total coupon count and removing date and individual coupon per day. 

demo_all_agg <- merge(demo_all_agg,coupon_total_counts)
demo_all_agg <- demo_all_agg  %>% select(1,4:12)

#Remove unnecesary datasts 

rm(coupon_total_counts,demo_all,demographics)


#-----------------------------------------------------------------------------

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

#-----------------------------------------------------------------------------

#******************************GRAPHS******************************

#Heterogeneity 

plotmeans(amount_spent ~ date, data = m1,xlab="Date",  ylab="Amount Spent",
          main = "Date Heterogeneity Table ")

plotmeans(amount_spent ~ household_id, data = m1,xlab="Household ID",  ylab="Amount Spent",
          main = "Household Heterogeneity Table")

#Histograms 

#Total Spent 
hist(demo_all_agg$total_spent, 
     main="Density Histogram for total spent", 
     xlab="Total Spent ", 
     border="white", 
     col="blue",
     las=1, 
     breaks=20)


hist(demo_all_agg$total_spent, 
     main="Density Histogram for total spent", 
     xlab="Total Spent ", 
     border="white", 
     col="blue",
     las=1, 
     breaks=20,prob = TRUE)


lines(density(demo_all_agg$total_spent),col="red")


#Total Coupons 

hist(demo_all_agg$total_coupons, 
     main="Density Histogram for total coupons", 
     xlab="Total coupons ", 
     border="white", 
     col="blue",
     las=1, 
     breaks=20)


hist(demo_all_agg$total_coupons, 
     main="Density Histogram for total Coupons", 
     xlab="Total Coupons ", 
     border="white", 
     col="blue",
     las=1, 
     breaks=20,prob = TRUE)


lines(density(demo_all_agg$total_coupons),col="red")


#Scatterplots 

#Income vs total spent 

plot(demo_all_agg$income,demo_all_agg$total_spent,
     main="Scatterplot Income Vs Total Spent",
     xlab="Income ", ylab="Total Spent ", pch=19)

plot(demo_all_agg$household_size,demo_all_agg$total_spent,
     main="Scatterplot Income Vs Household Size",
     xlab="Household Size ", ylab="Total Spent ", pch=19)

plot(demo_all_agg$kids_count,demo_all_agg$total_spent,
     main="Scatterplot total spent Vs Kids Count",
     xlab="Kids Count ", ylab="Total Spent ", pch=19)

plot(demo_all_agg$age,demo_all_agg$total_spent,
     main="Scatterplot Total Spent Vs age",
     xlab="age ", ylab="Total Spent ", pch=19)



plot(demo_all_agg$home_ownership,demo_all_agg$total_spent,
     main="Scatterplot Income Vs age",
     xlab="age ", ylab="Total Spent ", pch=19)

plot(demo_all_agg$kids_count,demo_all_agg$total_coupons,
     main="Coupon exposure Vs Kids count",
     xlab="kids count ", ylab="Total coupons ", pch=19)

plot(demo_all_agg$household_size,demo_all_agg$total_coupons,
     main="Coupon exposure Vs Household Size",
     xlab="Household Size", ylab="Total coupons ", pch=19)

plot(demo_all_agg$income,demo_all_agg$total_coupons,
     main="Coupon exposure Vs Income",
     xlab="Income", ylab="Total coupons ", pch=19)


plot(demo_all_agg$total_coupons,demo_all_agg$total_spent,
     main="Coupon exposure Vs Total Spent",
     xlab="total coupons", ylab="Total spent ")
abline(lm(demo_all_agg$total_spent ~ demo_all_agg$total_coupons),col = "red")


#-----------------------Tests for Statistical Significance

#create data frame that only includes the household numbers of coupon users
coupon_users <- coupon_red %>% 
  group_by(household_id) %>% 
  summarize(coup_user="yes")

#summarize total household spending
test <- m2 %>% 
  group_by(household_id) %>% 
  summarize(tot_spent=sum(amount_spent))

#merge total spending with coupon user info
test <- full_join(test,coupon_users,by="household_id")

#define non-users
test$coup_user[is.na(test$coup_user)] <- "no"

#split data frame into subsets of users and non-users
test_user <- as.data.frame(filter(test,coup_user=="yes"))
test_nonuser <- as.data.frame(filter(test,coup_user=="no"))

#density plot
ggplot(test,aes(x=tot_spent,color=coup_user)) + 
  geom_density() +
  labs(title = "Distribution of Total Household Spending",
       caption = "") +
  xlab("Total Household Spending") + ylab("Density") +
  scale_color_discrete(name = "Coupon User")

#------------------------------Relationcustomers spend more after start to use coupons 

trans <- get_transactions()

#create data frame that only lists the day on which a household first used a coupon
coupon_day_users <- coupon_red %>% 
  group_by(household_id) %>% 
  summarize(first_coup=min(redemption_date))

#merge above data frame with transaction data for those households that used coupons

users <- inner_join(trans,coupon_day_users,by=c("household_id"))
users <- users %>% 
  mutate(coup_start=ifelse(first_coup>transaction_timestamp,"no","yes")) %>%
  group_by(household_id,week,coup_start) %>% 
  summarize(weekly_spend=sum(sales_value),
            dummy=1)

#split data frame into two subsets, before coupon used and after coupon used
users_before <- filter(users,coup_start=="no")
users_after <- filter(users,coup_start=="yes")

#because each household first uses coupons at different times,
#the `users_before` subset should include negative trip numbers before a coupon
#was used such that the first trip is the most negative number, and the last is 0

users_before <- users_before %>%
  group_by(household_id) %>%
  mutate(cum_dummy=cumsum(dummy),
         trip=cum_dummy-max(cum_dummy)) %>%
  select(-dummy,-cum_dummy)

#similar to `users_before`, we want to track the cumulative trips after coupons
#were used such that the first trip is 0 and the last is the largest number
users_after <- users_after %>%
  group_by(household_id) %>%
  mutate(trip=cumsum(dummy)-1) %>%
  select(-dummy)

#bind rows
users2 <- bind_rows(users_before,users_after)

#plot the graph
ggplot(users2,aes(x=trip,y=weekly_spend,color=coup_start)) + 
  geom_smooth() +
  labs(title = "Relationship between customer spend after they start using coupons",
       caption = "") +
  xlab("Week Number (with respect to first coupon use)") + ylab("Weekly Spending (dollars)") +
  scale_color_discrete(name = "Used First Coupon" )


