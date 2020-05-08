# hse-midterm
HSE St.Petersburg - Midterm Thesis R Repository

**household_campaigns.R -** model to show campaign information (as 0 or 1) for each
household in every given date

**basic_model.R -** creates model with treatment, period and total_spent
variables with given date for each household and date

-----------------------------------------------

**TASKS**

**Task1 -** Divide households into two groups (Exposed to coupons vs not
exposed/exposed very low). Check how those exposed to campaigns differ from those not exposed (demographics, amount spent, frequency, etc.) If there are differences in demographics it’s likely that the treatment was not randomized.

**Task2 -** Figure out whether there was a period at the beginning of the year, when a substantial number of households were not exposed to any campaigns (or very few), while they were later exposed to some campaigns. Try different thresholds. For example, let’s consider January-March 2017, numberwise It’s okay if eventually we have 200 households not exposed to campaigns at all, while we have 400 households not exposed then, but exposed.

**MODEL 1 -** The basic model is then:
treatment=1 for those who were exposed to some campaign after march 2017 but not before

treatment=0 for those who were not exposed to any campaign at all

period2=1 for time>march 2017 and 0 otherwise

amount spent on day i=b0+b1*period2+b2*treatment+b3*(period2*treatment)+control variables

Frequencies/amounts purchases/average basket size/etc for January-march 2017 will be control variables.
