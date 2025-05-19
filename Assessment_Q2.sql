WITH monthly_transactions AS (
    SELECT 
        owner_id,
        DATE_FORMAT(transaction_date, '%Y-%m-01') AS transaction_month,
        COUNT(*) AS transaction_count
    FROM savings_savingsaccount
    GROUP BY owner_id, DATE_FORMAT(transaction_date, '%Y-%m-01')
),
customer_avg_transaction_monthly AS (
    SELECT 
        owner_id,
        AVG(transaction_count) AS avg_transactions_per_month
    FROM monthly_transactions
    GROUP BY owner_id
),
categorized AS (
    SELECT 
        CASE 
            WHEN AVG(avg_transactions_per_month) >= 10 THEN 'High Frequency'
            WHEN AVG(avg_transactions_per_month) BETWEEN 3 AND 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category,
        COUNT(*) AS customer_count,
        ROUND(AVG(avg_transactions_per_month), 1) AS avg_transactions_per_month
    FROM customer_avg_transaction_monthly
    GROUP BY 
        CASE 
            WHEN avg_transactions_per_month >= 10 THEN 'High Frequency'
            WHEN avg_transactions_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END
)
SELECT * FROM categorized;