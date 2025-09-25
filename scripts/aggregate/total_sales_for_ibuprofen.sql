-- calculate the sales trend over time of the Ibuprofen drug

WITH ProductSales AS (
    -- 1. Prepare daily sales data for Product ID 201 (Ibuprofen)
    SELECT
        t.sale_date,
        SUM(t.quantity * p.price) AS daily_revenue
    FROM transactions t
    JOIN products p ON t.product_id = p.product_id
    WHERE p.product_id = 201
    GROUP BY t.sale_date
    ORDER BY t.sale_date
)
SELECT
    sale_date,
    daily_revenue,

    -- Running Total: Uses SUM() and UNBOUNDED PRECEDING
    -- Calculates the cumulative revenue from the first day up to the current day.
    SUM(daily_revenue) OVER (
        ORDER BY sale_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total_revenue,

    -- 3-Day Moving Average: Uses AVG() and a ROWS frame
    -- Calculates the average revenue for the current day and the two previous days.
    AVG(daily_revenue) OVER (
        ORDER BY sale_date
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS avg_3_day_rows,

    -- 3-Day Moving Average: Uses AVG() and a RANGE frame (Less common for dates/time)
    -- This is often used for numeric columns. Since it's less meaningful on non-time data, 
    -- we'll just demonstrate the syntax, assuming a 3-unit range difference.
    AVG(daily_revenue) OVER (
        ORDER BY daily_revenue -- Must order by the metric itself for RANGE to work logically
        RANGE BETWEEN 5 PRECEDING AND 5 FOLLOWING
    ) AS avg_range_example

FROM ProductSales
ORDER BY sale_date;