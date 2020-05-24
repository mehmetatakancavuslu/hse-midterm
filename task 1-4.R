#---------------------------Task 1-4


#install required libraries 
library(dplyr)
library(tidyverse)
library(completejourney)
library(arsenal)
library(coin)

#Read CSV with coupon counts created in Task 1-1
df2 <- read.csv("couponcounts2.csv")

#Get all the demographic info 
demographics <- demographics


# Separate HS high exposed and low exposed 
separator <- 50
df_low_exposed2 <- subset(df2, coupon_count < separator)
df_high_exposed2 <- subset(df2, coupon_count >= separator)

# Create new df low exposed and high exposed  with demographics for analysis 
demo_low_exposed2 <- merge(df_low_exposed2, demographics)
demo_high_exposed2 <-  merge(df_high_exposed2, demographics)


# Create a new df for coupon counts distributed as High > separator 
# & Low < separator in order to analyze them together in a table. 
demo_all2 <-  merge(df2, demographics)

demo_all2 <- demo_all2 %>%
  select(-household_id) %>%
  mutate(coupon_count = ifelse(coupon_count > separator, "high", "low")) %>%
  mutate(coupon_count = factor(coupon_count))


# Create Descriotive table of the data separated by high and low exposed
table_three <- tableby(coupon_count ~ ., data = demo_all2)
summary(table_three, title = "Demographic Data for High and Low exposure HH",
        text=TRUE)

# Create a matrix version of demo_all in order to analyze by summary statistics 
# the difference in the data. 

demo_all_matrix2 <- data.matrix(demo_all2, rownames.force = NA)

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

table_four <- tableby(coupon_count ~ ., data = demo_all_matrix2,
                     control = my_controls)
summary(table_four, title = "Demographic Data statistics differences for High 
        and Low exposure HH Task 1-4",
        text=TRUE)



# Run Separate kruskal-wallis test to confirm P values of the < 0.5 variables

kruskal.test(x = demo_all2$income, g = demo_all2$coupon_count)
kruskal.test(x = demo_all2$household_size, g = demo_all2$coupon_count)
kruskal.test(x = demo_all2$kids_count, g = demo_all2$coupon_count)

#our null hypothesis is that 2 samples are identical on variables p>0.05
# we fail to reject that they are not identical. However Household size
# and Kids count we can reject the null hypotesis as they have a considerably lower
# p value than 0.05


