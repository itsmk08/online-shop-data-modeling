# 🛒 End-to-End Relational & Dimensional Data Modeling  
## Online Shop 2024 – OLTP to Data Warehouse Implementation

---

## 📌 Project Overview

This project demonstrates the complete lifecycle of data modeling — from raw transactional data to a fully implemented dimensional data warehouse.

Using the Online Shop 2024 dataset from Kaggle, this project covers:

- Relational Data Modeling (ERD)
- Dimensional Modeling (Star Schema)
- SQL Database Implementation (DDL)
- ETL Logic & Analytical Queries (DML/DQL)
- Business Metrics & Insight Generation

The objective was to simulate a real-world data engineering and analytics workflow.

---

## 📊 Dataset Description

The dataset represents an e-commerce platform and contains multiple related tables:

- Customers  
- Orders  
- Order Items  
- Products  
- Payments  

It enables analysis of:

- Customer purchasing behavior  
- Product sales performance  
- Order trends over time  
- Payment status and activity  

---

# 🧱 Phase 1: Data Discovery

Core entities identified:

| Table | Purpose |
|-------|----------|
| Customers | Stores customer details |
| Orders | Records each order placed |
| Order_Items | Tracks products within each order |
| Products | Stores product information |
| Payments | Tracks payment transactions |

---

# 🔗 Phase 2: Relational Data Modeling (ERD)

A normalized transactional (OLTP) schema was designed with:

### Primary Relationships

- Customers → Orders (1:M)
- Orders → Order_Items (1:M)
- Products → Order_Items (1:M)
- Orders → Payments (1:1)

### Key Design Principles

- Primary Keys for entity uniqueness  
- Foreign Keys for referential integrity  
- Normalized structure to reduce redundancy  

This model supports operational transaction processing.

---

# ⭐ Phase 3: Dimensional Modeling (Star Schema)

To support analytics, a dimensional model was designed.

## 🧮 Fact Table: `fact_sales`

**Grain:**  
One row represents one product sold in one order on a specific date.

### Measures:
- quantity_sold
- price_at_purchase
- actual_price
- total_sales_amount

### Foreign Keys:
- customer_key
- product_key
- date_key
- payment_key
- order_key (degenerate dimension)

---

## 📐 Dimension Tables

### `dim_customer`
Customer attributes with surrogate keys for analytics.

### `dim_product`
Product attributes for category-level analysis.

### `dim_date`
Calendar breakdown supporting time-series analytics.

### `dim_payment`
Payment method and transaction status for financial analysis.

---

# 🗄 Phase 4: Database Implementation (DDL)

The conceptual models were implemented using SQL:

- OLTP transactional schema
- Dimensional star schema

### Implementation Highlights

- Appropriate data types (INTEGER, VARCHAR, NUMERIC, DATE, TIMESTAMP)
- Primary & Foreign Key constraints
- NOT NULL, UNIQUE, and CHECK constraints
- Referential integrity enforcement

This ensures a robust, optimized, and analytics-ready database structure.

---

# 📈 Phase 5: Business Logic & Analytics (DML/DQL)

After populating the dimensional model using ETL logic, analytical SQL queries were developed to answer practical business questions.

### SQL Techniques Used

- Joins
- Aggregations
- GROUP BY & HAVING
- Filtering
- Window Functions

---

# 📊 Business Metrics Implemented

| Metric | Business Insight |
|--------|------------------|
| High-Value Regions | Identifies regions with above-average order value |
| Unsold Products | Detects products with zero sales |
| Top Customers | Finds highest revenue-generating customers |
| Monthly Revenue by Category | Tracks category-level performance over time |

These metrics demonstrate how transactional data can be transformed into actionable business insights.

---

# 🛠 Technologies Used

- SQL (DDL, DML, DQL)
- Relational Data Modeling
- Dimensional Modeling (Star Schema)
- ETL Logic Implementation
- Analytical Query Design

---

# 📂 Repository Structure
```
online-shop-data-modeling/
│
├── ddl/
│   ├── oltp_schema.sql
│   └── data_warehouse_schema.sql
│
├── dml/
│   ├── etl_scripts.sql
│   └── analytics_queries.sql
│
├── erd/
│   └── relational_erd.png
│
├── star_schema/
│   └── star_schema_design.png
│
└── README.md
```
---

# 🎯 Key Learnings

- Designing normalized OLTP schemas
- Converting relational models into dimensional star schemas
- Defining fact table grain correctly
- Implementing surrogate keys
- Writing business-driven analytical SQL queries
- Structuring scalable data warehouse architecture

---

# 🚀 Project Significance

This project demonstrates the ability to:

- Translate raw business data into structured database systems
- Implement both transactional and analytical data models
- Bridge data engineering and business analytics
- Deliver insight-ready data infrastructure
