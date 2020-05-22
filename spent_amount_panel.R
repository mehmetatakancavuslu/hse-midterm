library(completejourney)
library(dplyr)

# Get all the transactions
transactions <- get_transactions()

# Get all the unique household_ids and dates
households_all <- unique(transactions$household_id)
households_all <- sort(as.numeric(households_all), decreasing = FALSE)
households_all <- as.character(households_all)
# # Get all the distinct  dates
dates_all <- unique(as.Date(transactions$transaction_timestamp,
                            format = "%Y-%m-%d"))
dates_all <- sort(dates_all, decreasing = FALSE)

# Create the skeleton of the dataset
k.households <- length(households_all)
k.dates <- length(dates_all)
household_spendings <- data.frame(matrix(NA, ncol = 3,
                                         nrow = k.households * k.dates))
col_names <- c("household_id", "date", "amount_spent")
names(household_spendings) <- col_names

# Fill the household_ids and dates
household_spendings$household_id <- rep(households_all, each = k.dates)
household_spendings$date <- rep(dates_all, times = k.households)

# Convert transactions timestamps to date objects
transactions$transaction_timestamp <- as.Date(
  transactions$transaction_timestamp,
  format = "%Y-%m-%d"
)

# Trim down transactions dataframe
transactions[ ,c('column1', 'column2')] <- list(NULL)
