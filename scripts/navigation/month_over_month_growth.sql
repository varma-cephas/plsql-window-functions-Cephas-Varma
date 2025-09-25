-- month over month analysis of three months, Jan, Feb, Mar
WITH MonthlyRevenue AS (
    -- 1. Aggregate the total revenue for each month
    SELECT
        -- Extract the start date of the month for easy grouping and ordering
        TRUNC(t.sale_date, 'MM') AS sale_month,
        -- Calculate the total revenue for all products in that month
        SUM(t.quantity * p.price) AS current_month_revenue
    FROM transactions t
    JOIN products p ON t.product_id = p.product_id
    -- We can filter here just to be safe, but the data is already in 2025
    WHERE t.sale_date BETWEEN TO_DATE('2025-01-01', 'YYYY-MM-DD') AND TO_DATE('2025-03-31', 'YYYY-MM-DD')
    GROUP BY TRUNC(t.sale_date, 'MM')
)
SELECT
    sale_month,
    current_month_revenue,

    -- LAG(): Gets the revenue from the previous row (i.e., the previous month)
    LAG(current_month_revenue, 1) OVER (ORDER BY sale_month) AS previous_month_revenue,

    -- Growth Percentage Calculation: (Current - Previous) / Previous * 100
    -- NVL is used to return NULL for the first month's growth (since there's no prior period)
    ROUND(
        (current_month_revenue - LAG(current_month_revenue, 1) OVER (ORDER BY sale_month))
        / LAG(current_month_revenue, 1) OVER (ORDER BY sale_month)
        * 100,
        2
    ) AS growth_percentage
FROM MonthlyRevenue
ORDER BY sale_month;