SELECT
    u.id AS user_id,
    TIMESTAMPDIFF(MONTH, u.date_joined, NOW()) AS tenure_months,
    SUM(s.confirmed_amount) / 100 AS total_transaction_naira,
    ROUND((
        (SUM(s.confirmed_amount) / 100) / NULLIF(TIMESTAMPDIFF(MONTH, u.date_joined, NOW()), 0)
    ) * 12 * 0.001, 2) AS estimated_clv
FROM
    users_customuser u
JOIN
    savings_savingsaccount s ON u.id = s.owner_id
GROUP BY
    u.id, u.date_joined
ORDER BY
    estimated_clv DESC;