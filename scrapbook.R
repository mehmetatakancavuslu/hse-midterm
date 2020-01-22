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
# Get all the distinct campaign starting dates
campaign_start_dates <- unique(campaign_descriptions$start_date)
campaign_start_dates <- sort(campaign_start_dates, decreasing = FALSE)
# Get all the campaign_ids
campaigns_all <- unique(campaign_descriptions$campaign_id)

# Create the skeleton of the dataset
k.households <- length(households_all)
k.dates <- length(campaign_start_dates)
k.campaigns <- length(campaigns_all)
household_campaigns <- data.frame(matrix(NA, ncol = 2 + k.campaigns,
                                            nrow = k.households * k.dates))
col_names <- c("household_id", "date", campaigns_all)
names(household_campaigns) <- col_names

# Fill the dataframe, houseld_ids and dates
household_campaigns$household_id <- rep(households_all, each = k.dates)
household_campaigns$date <- rep(campaign_start_dates, times = k.households)

## Example
# Get all campaing information for household_id = 1
for(i in 1:length(households_all)) {
  print(i)
  temp_id <- as.character(i)
  temp_df <- campaigns %>% filter(household_id == temp_id) %>%
    left_join(., campaign_descriptions, by="campaign_id") %>% arrange(start_date)
  # Iterate through temp to get campaign dates one by one
  for(j in 1:nrow(temp_df)) {
    campaign_id <- temp_df[j, 1]$campaign_id
    start_date <- temp_df[j, 4]$start_date
    end_date <- temp_df[j, 5]$end_date
    # Iterate through main dataset to write campaigns in respective columns
    for(k in 1:nrow(household_campaigns)) {
      temp_row <- household_campaigns[k,]
      print(k)
      if(temp_row$household_id == temp_id) {
        # Check each row in main dataset for date comparision
        if(temp_row$date >= start_date & temp_row$date < end_date) {
          household_campaigns[k, as.numeric(campaign_id) + 2] <- 1
        } else {
          household_campaigns[k, as.numeric(campaign_id) + 2] <- 0
        }
      }
    }
  }
}
