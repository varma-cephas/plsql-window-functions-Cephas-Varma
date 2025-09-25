-- Calculate the total money spent by each customer.
WITH CustomerRevenue AS (
    SELECT
        c.customer_id,
        c.name AS customer_name,
        -- Calculate the total revenue (quantity * price) for all their transactions
        SUM(t.quantity * p.price) AS total_revenue
    FROM transactions t
    JOIN products p ON t.product_id = p.product_id -- Link transactions to product prices
    JOIN customers c ON t.customer_id = c.customer_id -- Link transactions to customer names
    -- Group the results so we get one total revenue value for each unique customer
    GROUP BY c.customer_id, c.name
)
-- Now select the calculated revenue and apply all four ranking functions.
SELECT
    customer_name,
    total_revenue,
    -- ROW_NUMBER: Gives a unique number to every customer, starting at 1. 
    -- If two customers have the same revenue (a tie), they get different, sequential numbers.
    ROW_NUMBER() OVER (ORDER BY total_revenue DESC) AS rn,

    -- RANK: Gives the same number to tied customers. 
    -- It then skips the next number. (Example: 1, 2, 2, 4)
    RANK() OVER (ORDER BY total_revenue DESC) AS rnk,

    -- DENSE_RANK: Gives the same number to tied customers. 
    -- It does NOT skip the next number. (Example: 1, 2, 2, 3) This is often used for "Top N" lists.
    DENSE_RANK() OVER (ORDER BY total_revenue DESC) AS drnk,

    -- PERCENT_RANK: Shows a customer's rank as a percentile (from 0 to 1). 
    -- This tells you how well they scored relative to everyone else.
    PERCENT_RANK() OVER (ORDER BY total_revenue DESC) AS prnk
FROM CustomerRevenue
-- Show the customer with the highest revenue first
ORDER BY total_revenue DESC;