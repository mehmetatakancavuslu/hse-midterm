# Using Machine Learning Methods to Evaluate Factors Affecting the Performance of Marketing Campaigns: an Application to a Retailer's Transactional Data

## SCRIPTS & CSVs

**household_campaigns.R -** model to show campaign information (as 0 or 1) for each
household in every given date

**basic_model.R -** creates model with treatment, period and total_spent
variables with given date for each household and date

**couponcounts.csv -** Csv obtained from task1-1

**couponcounts2.csv -** Csv obtained from task1-3

## TASKS

### Task1

**Task 1-1:** Divide households into two groups (Exposed to coupons vs not
exposed). Dataframe shows households and their respective number of days they 
are exposed at least one coupon campaign.

**Task 1-2:** Check how those exposed to campaigns differ from those not exposed (demographics, amount spent, frequency, etc.) If there are differences in demographics it’s likely that the treatment was not randomized.

**Task 1-3:** Divide households into two groups (Exposed to coupons vs not
exposed). This time use coupon-days for each household, which means if one 
household is exposed to 2 campaigns at the same day, it is counted as 2 (In the
task1-1 it was counted as 1)

**Task 1-4:** Check how those exposed to campaigns differ from those not exposed (demographics, amount spent, frequency, etc.) If there are differences in demographics it’s likely that the treatment was not randomized.

### Task2

Testing relation between coupon exposures and household spent in couple of
different methods and models.

#### MODEL 1

Build a fixed effects regression model with fixed effects of customers (as many dummy variables as there are customers) and fixed effects of time periods (364-365 dummy variables). 

These fixed effects will capture household characteristics that do not change over time and time effects (like for example there was high promotional activity other than coupons on that day+any holiday related things, etc.).

In other words, it's like building a regression:
lm(spend~customer_id+date+coupon1+coupon2+coupon3 etc.) 

Simpler model can have just a variable showing how many coupons were available to that customer on that day. In a more complex machine learning model you can include coupon types and more.

#### MODEL 2

Look at how the number of coupons of different types (Type A, B and C) available to a customer “i” on day “t” impacts how much they spend on that day. If the coupon has been used, then the day of its use is the last day when it was available to the customer.

Since the model has limitation (0 reflects not a zero purchase, but the fact that a person decided not to go shopping on this day), then not a regular regression is built, but a two-step one (at the first stage the probability of purchase is estimated, at the second - the purchase amount ) Thus, one of the suitable model types is the Tobit model with random slope coefficients.

Random coefficients for the effect of each coupon type will be neglected this year, it can be done next year and it as a direction for future research. 


