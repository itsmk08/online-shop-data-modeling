-- Dim Date
INSERT INTO dim_date (date_key, full_date, day, month, year, quarter, weekday)
SELECT DISTINCT
    TO_CHAR(d, 'YYYYMMDD')::INT AS date_key,
    d AS full_date,
    EXTRACT(DAY FROM d)::INT AS day,
    EXTRACT(MONTH FROM d)::INT AS month,
    EXTRACT(YEAR FROM d)::INT AS year,
    EXTRACT(QUARTER FROM d)::INT AS quarter,
    TO_CHAR(d, 'Day') AS weekday
FROM (
    SELECT order_date::DATE AS d FROM orders
) sub
WHERE d IS NOT NULL;

-- Dim Customer
INSERT INTO dim_customer (customer_key, first_name, last_name, address, email, phone_number)
SELECT customer_id, first_name, last_name, address, email, phone_number
FROM customers
WHERE customer_id IS NOT NULL;

-- Dim Product
INSERT INTO dim_product (product_key, product_name, product_category)
SELECT product_id, product_name, category
FROM products
WHERE product_id IS NOT NULL;

-- Dim Payment
INSERT INTO dim_payment (payment_key, payment_method, transaction_status)
SELECT payment_id, payment_method, transaction_status
FROM payments
WHERE payment_id IS NOT NULL;

CREATE INDEX idx_dim_date_full_date ON dim_date(full_date);
CREATE INDEX idx_dim_payment_method_status
ON dim_payment(payment_method, transaction_status);


-- Fact Sales
-- Simple Fact Sales Insert
INSERT INTO fact_sales (
    order_key,
    customer_key,
    product_key,
    date_key,
    payment_key,
    quantity_sold,
    price_at_purchase,
    actual_price,
    total_sales_amount
)
SELECT
    o.order_id AS order_key,
    o.customer_id AS customer_key,        -- natural key from OLTP
    oi.product_id AS product_key,         -- natural key from OLTP
    TO_CHAR(o.order_date, 'YYYYMMDD')::INT AS date_key, -- simple date_key
    p.payment_id AS payment_key,          -- may be NULL if unpaid
    oi.quantity AS quantity_sold,
    oi.price_at_purchase,
    oi.price_at_purchase AS actual_price,
    oi.quantity * oi.price_at_purchase AS total_sales_amount
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
LEFT JOIN payments p ON o.order_id = p.order_id;


