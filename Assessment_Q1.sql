-- Find customers with both savings and investment plans, sorted by total deposits
SELECT 
    u.id AS owner_id,
    u.name AS name,
    COUNT(DISTINCT CASE WHEN p.is_regular_savings = 1 THEN p.id END) AS savings_count,
    COUNT(DISTINCT CASE WHEN p.is_a_fund = 1 THEN p.id END) AS investment_count,
    COALESCE(SUM(p.amount) / 100.0, 0) AS total_deposits -- Convert kobo to naira
FROM 
    users_customuser u
    INNER JOIN plans_plan p ON u.id = p.owner_id
WHERE 
    COALESCE(p.amount, 0) > 0
GROUP BY 
    u.id, u.name
HAVING 
    COUNT(DISTINCT CASE WHEN p.is_regular_savings = 1 THEN p.id END) >= 1
    AND COUNT(DISTINCT CASE WHEN p.is_a_fund = 1 THEN p.id END) >= 1
ORDER BY 
    total_deposits DESC;