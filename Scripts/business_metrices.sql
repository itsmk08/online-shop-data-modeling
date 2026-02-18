
-- Phase 5: Business Logic & Analytics
-- SQL Queries for Reporting & Insights

-- 1️ Revenue Analysis: Total revenue by month and product category
-- Shows which product categories generate the most revenue per month.
SELECT
    dd.year,
    dd.month,
    dp.product_category,
    SUM(fs.total_sales_amount) AS total_revenue
FROM fact_sales fs
JOIN dim_date dd ON fs.date_key = dd.date_key
JOIN dim_product dp ON fs.product_key = dp.product_key
GROUP BY dd.year, dd.month, dp.product_category
ORDER BY dd.year, dd.month, dp.product_category;


-- 2️ Customer Insights: Top 10 customers by total spend
-- Identify the most valuable customers.
SELECT
    dc.customer_key,
    dc.first_name || ' ' || dc.last_name AS customer_name,
    SUM(fs.total_sales_amount) AS total_spent,
    RANK() OVER (ORDER BY SUM(fs.total_sales_amount) DESC) AS rank
FROM fact_sales fs
JOIN dim_customer dc ON fs.customer_key = dc.customer_key
GROUP BY dc.customer_key, dc.first_name, dc.last_name
ORDER BY rank
LIMIT 10;


-- 3 Advanced Joins: Products that have never been sold
-- Explanation: Identify products with zero sales.
SELECT
    p.product_id,
    p.product_name,
    p.category
FROM products p
LEFT JOIN fact_sales fs ON p.product_id = fs.product_key
WHERE fs.sales_key IS NULL
ORDER BY p.product_id;


-- 4 Aggregations: Regions with average sales greater than a threshold
-- Assumes customers table has a 'region' column
-- Explanation: Shows high-performing regions.
SELECT
    c.address AS region,
    AVG(fs.total_sales_amount) AS avg_sales
FROM fact_sales fs
JOIN dim_customer c ON fs.customer_key = c.customer_key
GROUP BY c.address
HAVING AVG(fs.total_sales_amount) > 1000   -- example threshold 1000
ORDER BY avg_sales DESC;


-- 6️⃣ Bonus: Monthly revenue trend for Top Product Categories
-- Explanation: Useful for visual charts in presentation
SELECT
    dd.year,
    dd.month,
    dp.product_category,
    SUM(fs.total_sales_amount) AS monthly_revenue
FROM fact_sales fs
JOIN dim_date dd ON fs.date_key = dd.date_key
JOIN dim_product dp ON fs.product_key = dp.product_key
GROUP BY dd.year, dd.month, dp.product_category
ORDER BY dd.year, dd.month, monthly_revenue DESC;

