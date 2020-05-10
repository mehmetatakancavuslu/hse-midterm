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
separator <- 69
df_low_exposed <- subset(df, coupon_count < separator)
df_high_exposed <- subset(df, coupon_count >= separator)

# Create new df low exposed and high exposed  with demographics for analysis 
demo_low_exposed <- merge(df_low_exposed, demographics)
demo_high_exposed <-  merge(df_high_exposed, demographics)

summary(demo_low_exposed)
summary(demo_high_exposed)

# Create a new df for coupon counts distributed as High > 69 & Low < 69
#in order to analyze them together in a table. 
demo_all <-  merge(df, demographics)
summary((demo_all))

demo_all <- demo_all %>%
  select(-household_id) %>%
  mutate(coupon_count = ifelse(coupon_count > 69, "high", "low")) %>%
  mutate(coupon_count = factor(coupon_count))



# Create Descriotive table of the data separated by high and low exposed
table_one <- tableby(coupon_count ~ ., data = demo_all)
summary(table_one, title = "Demographic Data for High and Low exposure HH",
        text=TRUE)

# Create a matrix version of demo_all in order to analyze by summary statistics 
# the difference in the data. 

demo_all_matrix <- data.matrix(demo_all, rownames.force = NA)

#Create controls for the summary statistics table for equivalence testing
my_controls <- tableby.control(
  test = T,
  total = T,
  numeric.test = "kwt", cat.test = "chisq",
  numeric.stats = c("meansd", "medianq1q3", "range", "Nmiss2"),
  cat.stats = c("countpct", "Nmiss2"),
  stats.labels = list(
    meansd = "Mean (SD)",
    medianq1q3 = "Median (Q1, Q3)",
    range = "Min - Max",
    Nmiss2 = "Missing"))

#Create a new table displaying controlled variables. 

table_two <- tableby(coupon_count ~ ., data = demo_all_matrix,
                     control = my_controls)
summary(table_two, title = "Demographic Data statistics differences for High 
        and Low exposure HH",
        text=TRUE)



# Run Separate kruskal-wallis test to confirm P values

kruskal.test(x = demo_all$age, g = demo_all$coupon_count)
kruskal.test(x = demo_all$income, g = demo_all$coupon_count)
kruskal.test(x = demo_all$home_ownership, g = demo_all$coupon_count)

#our null hypothesis is that 2 populations are identical, since p>0.05
#on all variables we fail to reject that they are not identical. 






