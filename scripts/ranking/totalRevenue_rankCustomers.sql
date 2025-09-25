SELECT
    c.customer_id,
    c.name AS customer_name,
    SUM(t.quantity * p.price) AS total_revenue
FROM transactions t
JOIN products p ON t.product_id = p.product_id
JOIN customers c ON t.customer_id = c.customer_id
GROUP BY c.customer_id, c.name