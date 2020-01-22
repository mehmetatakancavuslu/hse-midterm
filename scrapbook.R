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
# Get all the distinct campaign starting dates
campaign_start_dates <- unique(campaign_descriptions$start_date)
# Get all the campaign_ids
campaigns_all <- unique(campaign_descriptions$campaign_id)

# Create the skeleton of the dataset
k.households <- length(households_all)
k.dates <- length(campaign_start_dates)
k.campaigns <- length(campaigns_all)
household_campaigns.df <- data.frame(matrix(NA, ncol = 2 + k.campaigns,
                                            nrow = k.households * k.dates))
campaign_names <- paste("campaign", campaigns_all, sep = "")
col_names <- c("household_id", "date", campaign_names)
names(household_campaigns.df) <- col_names
