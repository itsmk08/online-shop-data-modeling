
-- 1. Customers Table
-- OLTP Tables
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,           -- PK
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    address VARCHAR(200),
    email VARCHAR(100) UNIQUE,             -- Unique identifier
    phone_number VARCHAR(20)
);

-- Optional index on email
CREATE INDEX idx_customers_email ON customers(email);


-- 2. Orders Table
CREATE TABLE orders (
    order_id INT PRIMARY KEY,               -- PK
    customer_id INT NOT NULL,               -- FK to customers
    order_date DATE NOT NULL,
    total_price NUMERIC(10,2) NOT NULL CHECK (total_price >= 0),
    CONSTRAINT fk_orders_customer FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
);

-- Index on customer_id for joins
CREATE INDEX idx_orders_customer_id ON orders(customer_id);

-- 3. Products Table
CREATE TABLE products (
    product_id INT PRIMARY KEY,             -- PK
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50),
    price NUMERIC(10,2) NOT NULL CHECK (price > 0)
);

-- Index on category for filtering
CREATE INDEX idx_products_category ON products(category);

-- 4. Order_Items Table
CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY,          -- PK
    order_id INT NOT NULL,                  -- FK to orders
    product_id INT NOT NULL,                -- FK to products
    quantity INT NOT NULL CHECK (quantity > 0),
    price_at_purchase NUMERIC(10,2) NOT NULL CHECK (price_at_purchase > 0),
    CONSTRAINT fk_items_order FOREIGN KEY (order_id) REFERENCES orders(order_id),
    CONSTRAINT fk_items_product FOREIGN KEY (product_id) REFERENCES products(product_id)
);


-- Indexes for joins
CREATE INDEX idx_order_items_order_id ON order_items(order_id);
CREATE INDEX idx_order_items_product_id ON order_items(product_id);

-- 5. Payments Table
CREATE TABLE payments (
    payment_id INT PRIMARY KEY,             -- PK
    order_id INT NOT NULL,                  -- FK to orders
    payment_method VARCHAR(50) NOT NULL,
    amount NUMERIC(10,2) NOT NULL CHECK (amount >= 0),
    transaction_status VARCHAR(20) NOT NULL,
    CONSTRAINT fk_payments_order FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

-- Index for joins
CREATE INDEX idx_payments_order_id ON payments(order_id);


-- OLAP Table
-- Customers Dimension (natural/business key from OLTP)
CREATE TABLE dim_customer (
    customer_key INT PRIMARY KEY,   -- natural/business key
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    address VARCHAR(255),
    email VARCHAR(255) UNIQUE,
    phone_number VARCHAR(20)
);

-- Products Dimension (natural/business key from OLTP)
CREATE TABLE dim_product (
    product_key INT PRIMARY KEY,    -- natural/business key
    product_name VARCHAR(200) NOT NULL,
    product_category VARCHAR(100)
);

-- Date Dimension
CREATE TABLE dim_date (
    date_key INT PRIMARY KEY,         -- YYYYMMDD format
    full_date DATE NOT NULL,
    day INT NOT NULL,
    month INT NOT NULL,
    year INT NOT NULL,
    quarter INT NOT NULL,
    weekday VARCHAR(20)
);

-- Payment Dimension (natural/business key)
CREATE TABLE dim_payment (
    payment_key INT PRIMARY KEY,   -- natural/business key
    payment_method VARCHAR(50) NOT NULL,
    transaction_status VARCHAR(50) NOT NULL
);


-- =====================================================
-- 3️⃣ Fact Table
-- =====================================================

CREATE TABLE fact_sales (
    sales_key SERIAL PRIMARY KEY,     -- true surrogate key
    order_key INT NOT NULL,           -- degenerate dimension
    customer_key INT NOT NULL,        -- FK to dim_customer (natural key)
    product_key INT NOT NULL,         -- FK to dim_product (natural key)
    date_key INT NOT NULL,            -- FK to dim_date
    payment_key INT,                  -- FK to dim_payment (natural key)
    quantity_sold INT NOT NULL CHECK (quantity_sold > 0),
    price_at_purchase DECIMAL(12,2) NOT NULL CHECK (price_at_purchase >= 0),
    actual_price DECIMAL(12,2),       -- after discount, taxes, etc.
    total_sales_amount DECIMAL(12,2),
    FOREIGN KEY (customer_key) REFERENCES dim_customer(customer_key),
    FOREIGN KEY (product_key) REFERENCES dim_product(product_key),
    FOREIGN KEY (date_key) REFERENCES dim_date(date_key),
    FOREIGN KEY (payment_key) REFERENCES dim_payment(payment_key)
);

-- Indexes for analytics
CREATE INDEX idx_fact_sales_customer ON fact_sales(customer_key);
CREATE INDEX idx_fact_sales_product ON fact_sales(product_key);
CREATE INDEX idx_fact_sales_date ON fact_sales(date_key);
CREATE INDEX idx_fact_sales_payment ON fact_sales(payment_key);



