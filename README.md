DataAnalytics-Assessment

This repository contains SQL queries for the SQL Proficiency Assessment, analyzing customer data in the `adashi_assessment-1.sql` database. The assessment includes four questions addressing customer segmentation, transaction frequency, account inactivity, and customer lifetime value (CLV).


Files
- `Assessment_Q1.sql`: Identifies high-value customers with both funded savings and investment plans.
- `Assessment_Q2.sql`: Analyzes transaction frequency, categorizing customers as High, Medium, or Low Frequency.
- `Assessment_Q3.sql`: Detects active accounts with no inflow transactions in the last 365 days.
- `Assessment_Q4.sql`: Estimates Customer Lifetime Value (CLV) based on tenure and transaction volume.
- `README.md`: This file, documenting the approach and challenges.

Approach
Q1: Joined `users_customuser` and `plans_plan` to count savings (`is_regular_savings = 1`) and investment (`is_a_fund = 1`) plans with positive `amount`, grouping by customer and filtering for those with both plan types.

Q2: Calculated average transactions per month from `savings_savingsaccount`, using `transaction_date` for monthly grouping, and categorized customers based on transaction frequency.

Q3: Identified inactive savings and investment plans in `plans_plan` with no inflows in 365 days, using `transaction_date` and checking `withdrawals_withdrawal`.

Q4: Estimated CLV using `savings_savingsaccount`, calculating tenure with `transaction_date` and profit as 0.1% of transaction value.



Challenges
- Q2 failed with `Error Code: 1054. Unknown column 's.type'`. Removed `WHERE LOWER(s.type) = 'savings'` as `savings_savingsaccount` lacks a `type` column.
- Q4 output initially lacked `name` column; added `u.name` to match expected output (`customer_id`, `name`, `tenure_months`, `total_transactions`, `estimated_clv`).
- Encountered `Error Code: 1054` for `u.signup_date`, `s.created_at`, and `p.created_at` in Q4. Used `MIN(s.transaction_date)` from `savings_savingsaccount` for `tenure_months`, which produced correct output.
- Q1 confirmed working with `plans_plan` using `is_regular_savings = 1`, `is_a_fund = 1`, and `amount`.
- Q4 confirmed working with `transaction_date` and `confirmed_amount` in `savings_savingsaccount`.
- Used `transaction_date` in Q2 and Q3 to align with Q4; assumed consistent across `savings_savingsaccount`, `plans_plan`, and `withdrawals_withdrawal`.
- Used MySQL syntax (`TIMESTAMPDIFF`, `DATE_FORMAT`, `DATEDIFF`) to match environment.

## Notes
- All queries were tested successfully in MySQL 

