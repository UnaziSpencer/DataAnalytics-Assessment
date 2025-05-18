-- Calculate Customer Lifetime Value (CLV) based on tenure and transaction volume
WITH CustomerMetrics AS (
    SELECT 
        u.id AS customer_id,
        u.name,
        TIMESTAMPDIFF(MONTH, MIN(s.transaction_date), CURRENT_DATE) AS tenure_months,
        COUNT(s.id) AS total_transactions,
        COALESCE(SUM(s.confirmed_amount) / 100.0, 0) AS total_transaction_value
    FROM 
        users_customuser u
        LEFT JOIN savings_savingsaccount s ON u.id = s.owner_id
    GROUP BY 
        u.id, u.name
)
SELECT 
    customer_id,
    name,
    tenure_months,
    total_transactions,
    ROUND(
        CASE 
            WHEN tenure_months <= 0 THEN 0
            ELSE (total_transactions / GREATEST(tenure_months, 1)) * 12 * (total_transaction_value * 0.001)
        END, 
        2
    ) AS estimated_clv
FROM 
    CustomerMetrics
ORDER BY 
    estimated_clv DESC;