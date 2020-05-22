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
household_spendings <- data.frame(matrix(NA, ncol = 2,
                                         nrow = k.households * k.dates))
col_names <- c("household_id", "date")
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
transactions[ ,c('store_id', 'basket_id', 'product_id', 'quantity',
                 'retail_disc', 'coupon_disc', 'coupon_match_disc',
                 'week')] <- list(NULL)
names(transactions) <- c('household_id', 'amount_spent', 'date')
# Add same household_id and date tuples together
transactions <- transactions %>% group_by(household_id, date) %>% summarise(amount_spent = sum(amount_spent))

# Merge transactions and household_spendings
household_spendings <- merge(household_spendings, transactions, by=c("household_id","date"), all=T)

# Make NAs 0
household_spendings[is.na(household_spendings)] <- 0

write.csv(household_spendings,'household_spendings.csv', row.names=FALSE)
