-- Find active accounts with no transactions in the last 365 days
SELECT 
    p.id AS plan_id,
    p.owner_id AS owner_id,
    CASE 
        WHEN p.is_regular_savings = 1 THEN 'Savings'
        WHEN p.is_a_fund = 1 THEN 'Investment'
        ELSE 'Unknown'
    END AS type,
    p.last_returns_date AS last_transaction_date,
    DATEDIFF(CURRENT_DATE, p.last_returns_date) AS inactivity_days
FROM 
    plans_plan p
WHERE 
    (p.is_regular_savings = 1 OR p.is_a_fund = 1)
    AND p.last_returns_date <= DATE_SUB(CURRENT_DATE, INTERVAL 365 DAY)
    AND COALESCE(p.amount, 0) > 0
ORDER BY 
    inactivity_days DESC;