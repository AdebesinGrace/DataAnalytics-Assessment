WITH savings AS (
    SELECT owner_id, COUNT(*) AS savings_count
    FROM plans_plan
    WHERE is_regular_savings = 1         
        AND amount > 0   -- Funded savings plans      
    GROUP BY owner_id),

investments AS (
    SELECT owner_id, COUNT(*) AS investment_count
    FROM plans_plan
    WHERE is_a_fund = 1                  
        AND amount > 0  -- Funded investment plans
    GROUP BY owner_id),

deposits AS (SELECT owner_id, ROUND(SUM(confirmed_amount) / 100.0, 2) AS total_deposits   -- Converting from kobo to naira
			FROM savings_savingsaccount
			GROUP BY owner_id)

SELECT 
    u.id AS owner_id,
    CONCAT(u.first_name, ' ', u.last_name) AS name,
    COALESCE(s.savings_count, 0) AS savings_count,
    COALESCE(i.investment_count, 0) AS investment_count,
    COALESCE(d.total_deposits, 0.0) AS total_deposits
FROM 
    users_customuser u
LEFT JOIN 
    savings s ON u.id = s.owner_id
LEFT JOIN 
    investments i ON u.id = i.owner_id
LEFT JOIN 
    deposits d ON u.id = d.owner_id
WHERE 
    COALESCE(s.savings_count, 0) > 0
    AND COALESCE(i.investment_count, 0) > 0
ORDER BY 
    total_deposits DESC;