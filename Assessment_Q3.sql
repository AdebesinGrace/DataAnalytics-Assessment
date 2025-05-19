SELECT p.id AS plan_id, p.owner_id,
	CASE 
        WHEN p.is_regular_savings = 1 THEN 'Savings'
        WHEN p.is_a_fund = 1 THEN 'Investment'
        ELSE 'Other' -- The Plan type savings or investment
    END AS type, 
    last_inflow.last_transaction_date,-- Date of last deposit into the account
    CASE 
        WHEN last_inflow.last_transaction_date IS NULL THEN NULL
        ELSE DATEDIFF(CURDATE(), last_inflow.last_transaction_date) -- how many days since last deposit date
		END AS inactivity_days 
FROM
    plans_plan p
LEFT JOIN (SELECT owner_id, MAX(transaction_date) AS last_transaction_date  -- Find the most recent deposit date for each owner
			FROM savings_savingsaccount
			WHERE confirmed_amount > 0  -- approve only deposit coming in
			GROUP BY owner_id) last_inflow ON p.owner_id = last_inflow.owner_id
WHERE  (p.is_regular_savings = 1 OR p.is_a_fund = 1)
		AND (last_inflow.last_transaction_date IS NULL 
        OR DATEDIFF(CURDATE(), last_inflow.last_transaction_date) > 365) -- Account with no deposit & with no deposit in the last 365days
ORDER BY
    (last_inflow.last_transaction_date IS NULL),  
    inactivity_days DESC,
    last_inflow.last_transaction_date;