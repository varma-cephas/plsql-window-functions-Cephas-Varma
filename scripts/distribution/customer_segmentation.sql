-- ranking customers based on the total number of items they purchased and then diving them into four equally sized groups
WITH CustomerPurchaseCounts AS (
    SELECT
        c.customer_id,
        c.name AS customer_name,
        -- Calculate the total quantity of items bought by each customer
        SUM(t.quantity) AS total_items_bought
    FROM transactions t
    JOIN customers c ON t.customer_id = c.customer_id
    GROUP BY c.customer_id, c.name
)
SELECT
    customer_name,
    total_items_bought,

    -- NTILE(4): Segments the customers into 4 nearly equal groups (quartiles).
    -- Customers with the highest 'total_items_bought' get assigned to tier 1.
    NTILE(4) OVER (ORDER BY total_items_bought DESC) AS purchase_ranking,

    -- CUME_DIST(): Calculates the cumulative distribution of the purchase count.
    -- This shows the percentage of customers who bought the same or fewer items.
    ROUND(
        CUME_DIST() OVER (ORDER BY total_items_bought ASC) * 100, 
        2
    ) AS purchase_distribution_percent

FROM CustomerPurchaseCounts
ORDER BY total_items_bought DESC;