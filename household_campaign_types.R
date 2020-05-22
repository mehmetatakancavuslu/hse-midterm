library(completejourney)
library(dplyr)

## Seperate campaigns as their types
## Type A, Type B, Type C
type_a <- campaign_descriptions %>% filter(campaign_type == "Type A")
type_a_campaigns <- type_a$campaign_id
type_a_columns <- paste("X", type_a_campaigns, sep="")

type_b <- campaign_descriptions %>% filter(campaign_type == "Type B")
type_b_campaigns <- type_b$campaign_id
type_b_columns <- paste("X", type_b_campaigns, sep="")

type_c <- campaign_descriptions %>% filter(campaign_type == "Type C")
type_c_campaigns <- type_c$campaign_id
type_c_columns <- paste("X", type_c_campaigns, sep="")

household_campaigns <- read.csv('household_campaigns.csv')
household_campaigns$X <- NULL

household_campaigns$TypeA <- rowSums(household_campaigns[ ,type_a_columns ], na.rm=TRUE)
household_campaigns$TypeB <- rowSums(household_campaigns[ ,type_b_columns ], na.rm=TRUE)
household_campaigns$TypeC <- rowSums(household_campaigns[ ,type_c_columns ], na.rm=TRUE)

all_campaigns_columns <- c(type_a_columns, type_b_columns, type_c_columns)
household_campaigns[ ,all_campaigns_columns] <- list(NULL)

write.csv(household_campaigns,'household_campaign_types.csv', row.names=FALSE)
