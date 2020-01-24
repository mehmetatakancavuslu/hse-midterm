## Basic Model with variables: Treatment, Period2
## treatment=1 exposed to some campaign after XYZ 2017 but not before
## treatment=0 not exposed to any campaign at all
## period2=1 for time>XYZ 2017 and 0 otherwise
## XYZ date will be the threshold coming from analysis
## Which will be used on the model of "Amount Spend on Day"
## Amount spent on day i=b0+b1*period2+b2*treatment+b3*(period2*treatment)+cv
## Cv(Control Variables): Frequencies/amounts purchases/average basket size/etc

library(completejourney)
household_campaigns <- read.csv("household_campaigns.csv")
household_campaigns$X <- NULL
campaigns_all <- unique(campaign_descriptions$campaign_id)
col_names <- c("household_id", "date", campaigns_all)
names(household_campaigns) <- col_names
household_campaigns$date <- as.Date(household_campaigns$date)

# Create model_df for model building
model_df <- data.frame(matrix(NA, ncol = 5,
                                         nrow = nrow(household_campaigns)))
names(model_df) <- c("household_id", "date", "amount_spent",
                                "treatment", "period2")
model_df$household_id <- household_campaigns$household_id
model_df$date <- household_campaigns$date
model_df$household_id <- as.character(model_df$household_id)
model_df$date <- as.Date(model_df$date)

# Get amount spent for each day
library(dplyr)
transactions <- get_transactions()
transactions$date <- as.Date(transactions$transaction_timestamp,
                            format = "%Y-%m-%d")
household_sales <- aggregate(sales_value ~ household_id + date,
                             data = transactions, sum)
# Assign the sales value from above dataset to the model dataframe
model_df <- merge(model_df, household_sales, by = c("household_id", "date"),
               all = TRUE)
# Assign 0 to days nothing is spent
model_df$sales_value[is.na(model_df$sales_value)] <- 0
model_df$amount_spent <- model_df$sales_value
model_df$sales_value <- NULL

# Set XYZ (treatment) date
XYZ <- as.Date("2017-03-01")

# Set period2 = 1 if date is after XYZ
model_df$period2[model_df$date >= XYZ] <- 1
model_df$period2[model_df$date < XYZ] <- 0

## Set the treatment 1 if household is exposed to any campaign after XYZ
# Create a new variable to check if any campaign is in progress in any given day
household_campaigns$c <- ((rowSums(household_campaigns[,campaigns_all] == 1)
                           > 0)* 1)
# Check if any campaign after given XYZ
for (i in as.numeric(unique((model_df$household_id)))) {
  print(i)
  temp <- 1 %in% household_campaigns$c[household_campaigns$household_id ==
                                 as.character(i) &
                                 household_campaigns$date >= XYZ]
  if(temp == TRUE) {
    model_df$treatment[model_df$household_id == as.character(i)] <- 1
  } else {
    model_df$treatment[model_df$household_id == as.character(i)] <- 0
  }
}

write.csv(model_df,'model_df.csv')
