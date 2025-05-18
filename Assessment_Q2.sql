-- Calculate average transactions per month and categorize by frequency
WITH TransactionCounts AS (
    SELECT 
        u.id AS customer_id,
        COUNT(s.id) AS total_transactions,
        COALESCE(TIMESTAMPDIFF(MONTH, MIN(s.created_on), CURRENT_DATE), 1) AS months_active,
        COUNT(s.id) / GREATEST(COALESCE(TIMESTAMPDIFF(MONTH, MIN(s.created_on), CURRENT_DATE), 1), 1) AS avg_transactions_per_month
    FROM 
        users_customuser u
        LEFT JOIN savings_savingsaccount s ON u.id = s.owner_id
    GROUP BY 
        u.id
)
SELECT 
    CASE 
        WHEN avg_transactions_per_month >= 10 THEN 'High Frequency'
        WHEN avg_transactions_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
        ELSE 'Low Frequency'
    END AS frequency_category,
    COUNT(customer_id) AS customer_count,
    ROUND(AVG(avg_transactions_per_month), 1) AS avg_transactions_per_month
FROM 
    TransactionCounts
GROUP BY 
    frequency_category
ORDER BY 
    avg_transactions_per_month DESC;