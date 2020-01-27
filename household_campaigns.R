## The complete journet dataset warm-up and idea scrapbook
# install.packages("completejourney")
library(completejourney)
library(dplyr)

## Dataframe containing each household promotion state in given date
## household_id - date - campaign 1 - campaign 2 - ...

# Get all the household_ids
transactions <- get_transactions()
households_all <- unique(transactions$household_id)
households_all <- sort(as.numeric(households_all), decreasing = FALSE)
households_all <- as.character(households_all)
# # Get all the distinct  dates
dates_all <- unique(as.Date(transactions$transaction_timestamp,
                            format = "%Y-%m-%d"))
dates_all <- sort(dates_all, decreasing = FALSE)
# Get all the campaign_ids
campaigns_all <- unique(campaign_descriptions$campaign_id)

# Create the skeleton of the dataset
k.households <- length(households_all)
k.dates <- length(dates_all)
k.campaigns <- length(campaigns_all)
household_campaigns <- data.frame(matrix(NA, ncol = 2 + k.campaigns,
                                            nrow = k.households * k.dates))
col_names <- c("household_id", "date", campaigns_all)
names(household_campaigns) <- col_names

# Fill the dataframe, houseld_ids and dates
household_campaigns$household_id <- rep(households_all, each = k.dates)
household_campaigns$date <- rep(dates_all, times = k.households)

# Fill the active campaigns with 1s
# Iterate through each household and get their specific campaign dataframes
for(i in as.numeric(households_all)) {
  print(i)
  temp_id <- as.character(i)
  temp_df <- campaigns %>% filter(household_id == temp_id) %>%
    left_join(., campaign_descriptions, by="campaign_id") %>% arrange(start_date)
  if(dim(temp_df)[1] > 0) {
    # Iterate through temp_df to get campaign dates one by one per household
    for(j in 1:nrow(temp_df)) {
      campaign_id <- temp_df[j, 1]$campaign_id
      start_date <- temp_df[j, 4]$start_date
      end_date <- temp_df[j, 5]$end_date
      # Assign values to main dataset
      household_campaigns[household_campaigns$household_id == temp_id &
                            household_campaigns$date >= start_date &
                            household_campaigns$date <= end_date,][campaign_id] <- 1
    }
  }
}

# Fill the NAs with 0s
household_campaigns[is.na(household_campaigns)] <- 0

# Write to csv for further use
write.csv(household_campaigns,'household_campaigns.csv')
