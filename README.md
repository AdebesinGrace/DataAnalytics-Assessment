# DataAnalytics-Assessment
## SQL Assessment

## Query 1: High-Value Customers with Multiple Products
The Goal is to Identify customers with at least one funded savings plan AND one funded investment plan, sorted by total deposits.

### Approach:
- Created 3 Common Table Expressions (CTEs): Savings, Investment, and Deposit.
- Calculated:* Number of funded savings plans.
             * Number of funded investment plans.
             * Total confirmed deposits (converted from kobo to naira).
- Used COALESCE to replace NULLs with 0 for accurate filtering and aggregation.
- Joined the above data with users_customuser to retrieve customer details.
- Filtered users with at least one savings and one investment plan.
- Sorted the result by total deposits in descending order to highlight high-value customers.


## Query 2: Transaction Frequency Analysis
The Goal is to Categorize customers based on average monthly transaction frequency.

### Approach:
- Grouped transactions by user and transaction month using DATE_FORMAT(transaction_date, '%Y-%m-01') to normalize all dates within the same month.
- Calculated the average number of transactions per user per month.
- Categorized users into:
 High Frequency (≥10 transactions/month)
 Medium Frequency (3–9 transactions/month)
 Low Frequency (<3 transactions/month)
- Produced a summary showing the number of users in each category and their average monthly transactions.


## Query 3: Account Inactivity Alert
The goal is to Identify all active accounts (savings or investments) with no transactions in the last 1 year (365 days) .

### Approach:
- Extracted the latest confirmed deposit date for each user.
- Joined with all savings and investment plans.
- Flagged plans as inactive if:
- No deposit has ever been made, or
- The last deposit was made over 365 days ago.

Calculated the number of days since the last deposit.

Sorted the output to highlight the most inactive plans.

## Query 4: Estimate Customer Lifetime Value (CLV)
The Goal is to Estimate each customer's CLV based on their deposits and tenure.

### Approach: For each user:

- Calculated tenure (in months) between account creation and the current date.
- Summed all confirmed deposits (converted from kobo to naira).
- Used the CLV formula:
CLV = (Total Confirmed Deposits / Tenure in Months) × 12 × Profit Margin
Assumptions:
- Profit Margin = 0.001 (0.1% per naira deposited).
- CLV is scaled to reflect annual value (×12).
- Handled divide-by-zero cases using NULLIF().




## Challenges Encountered
1. File Encoding Issue
Original SQL file was saved in UTF-32BE, which MySQL could not read.

Fix: Re-saved the file as UTF-8 using Notepad.

2. Monthly Grouping for Transactions
To group all transactions occurring in the same month, I used the format '%Y-%m-01'.

This helped standardize transaction dates for accurate monthly aggregation.

3. Divide-by-Zero in CLV Calculation
Some users had tenure less than one month, which could result in a division by zero.

Fix: Used NULLIF(tenure_months, 0) to avoid errors and return NULL when tenure is 0.
