


<img src="https://raw.githubusercontent.com/Md-Refat-Hosain/sql-data-warehouse-project/a6565f840f94ac618633b8605d25c93fef948760/image/Elephant%20Data%20Warehouse%20Pipeline.png" alt="Data Warehouse Banner" width="100%">

```text

```

![Image Description](https://github.com/Md-Refat-Hosain/sql-data-warehouse-project/blob/a6565f840f94ac618633b8605d25c93fef948760/image/Elephant%20Data%20Warehouse%20Pipeline.png?raw=true)

# **Enterprise Data Warehouse & Customer Analytics Engine**

#


#

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Database](https://img.shields.io/badge/Database-PostgreSQL%20%7C%20SQL-blue?logo=postgresql&logoColor=white)](#)
[![Data Modeling](https://img.shields.io/badge/Data%20Modeling-Star%20Schema-green)](#)
[![Analytics](https://img.shields.io/badge/Analytics-SQL%20Data%20Analysis-success)](#)
[![Status](https://img.shields.io/badge/Status-In%20Development-orange)](#)
```text

```

## 📌 Executive Overview



This project delivers an end-to-end Customer & Sales Data Warehouse designed to centralize raw transactional data and convert it into strategic business intelligence. By architecting a dimensional star schema, the warehouse integrates customer demographic profiles with sales performance metrics to streamline query execution and enable fast analytical reporting.

Through automated SQL transformations and exploratory data analysis (EDA), this solution provides critical visibility into customer behavior, purchasing patterns, and sales revenue drivers—empowering stakeholders to make data-driven growth decisions.

```text

```


## 🏗️ Architecture & Data Flow

### **Architecture Diagram:**

### After architecting & Pipeline design.
```text

```
 - Data flowing map from source to destination.

![Image Description](https://github.com/Md-Refat-Hosain/sql-data-warehouse-project/blob/a6565f840f94ac618633b8605d25c93fef948760/image/draw_io/s2.png?raw=true)
```text

```
- Set-up, creation & map out for Primary Key & Foreign Key (FK) for different stages & tables.

![Image Description](https://github.com/Md-Refat-Hosain/sql-data-warehouse-project/blob/main/image/draw_io/s.png?raw=true)

```text

```

## 📁 Repository Structure

### Folder Directory Tree:

```text
.
├── EDA/                     # Exploratory SQL scripts & customer analytics
├── datasets/                # Raw input datasets (CSV)
├── docs/                    # Data dictionary & governance documentation
├── Looker/PowerBI           # Loading
├── image/                   # Architectural diagrams, ERDs, and report screenshots
├── scripts/                 # DDL, DML, and Medallion Architecture, transformation scripts
├── tests/                   # Data quality & schema validation checks
├── LICENSE                  # Project license
└── README.md                # Master project documentation
```

```text

```

## 📐 Data Modeling & Schema Design

#### Identifying and mapping surrogate and business keys across source tables to establish primary-foreign key relationships and ensure referential integrity.
```text

```
- Performing source-to-target column mapping and attribute extraction to align raw ERP/CRM fields with dimensional table requirements.

![Image Description](https://github.com/Md-Refat-Hosain/sql-data-warehouse-project/blob/a6565f840f94ac618633b8605d25c93fef948760/image/draw_io/s5.png?raw=true)



![Image Description](https://github.com/Md-Refat-Hosain/sql-data-warehouse-project/blob/a6565f840f94ac618633b8605d25c93fef948760/image/draw_io/s4.png?raw=true)

```text
```

- Designing cross-system integration models to unify CRM and ERP data streams, enabling seamless relational querying and multi-source join paths for analytics.

![Image Description](https://github.com/Md-Refat-Hosain/sql-data-warehouse-project/blob/a6565f840f94ac618633b8605d25c93fef948760/image/draw_io/s3.png?raw=true)


```text

```

## ⚙️ Implementation & Execution Sequence

| Step | Phase | Description | Key Script / Path |
| :---: | :--- | :--- | :--- |
| **1** | **Ingestion** | Ingest raw sales & customer files | `/datasets/` |
| **2** | **ETL & Modeling** | Build Star Schema (Fact & Dimension tables) | `scripts/fact&dimension.sql` |
| **3** | **Quality Control** | Run foreign key & null value validations | `/tests/` |
| **4** | **Analytics (EDA)**| Generate customer revenue & behavior reports | `EDA/customer_report.sql` |

```text


```

## 🔍 Key Findings


Key analytical insights derived from exploratory SQL queries on the Gold layer:

#### Query: Total customer count grouped by country ?

```sql

SELECT 
    COALESCE(country, 'n/a') AS country,
    COUNT(customer_key) AS total_customers
FROM gold.dim_customers
GROUP BY country
ORDER BY total_customers DESC;
```

| country | total_customers |
| :--- | :--- |
| United States | 7,482 |
| Australia | 3,591 |
| United Kingdom | 1,913 |
| France | 1,810 |
| Germany | 1,780 |
| Canada | 1,571 |
| n/a | 337 |



#### Query: Total customer count grouped by gender ?


```sql
-- 
SELECT 
    COALESCE(gender, 'n/a') AS gender,
    COUNT(customer_key) AS total_customers
FROM gold.dim_customers
GROUP BY gender
ORDER BY total_customers DESC;
```

| gender | total_customers |
| :--- | :--- |
| Male | 9,341 |
| Female | 9,128 |
| n/a | 15 |



#### Query: Total products by category ?


```sql
-- 
SELECT 
    COALESCE(category, 'n/a') AS category,
    COUNT(product_key) AS total_products
FROM gold.dim_products
GROUP BY category
ORDER BY total_products DESC;
```

| category | total_products |
| :--- | :--- |
| Components | 127 |
| Bikes | 97 |
| Clothing | 35 |
| Accessories | 29 |
| n/a | 7 |



#### Query: Average costs in each category ?

```sql
-- 
SELECT 
    COALESCE(category, 'n/a') AS category,
    ROUND(AVG(cost), 2) AS avg_costs
FROM gold.dim_products
GROUP BY category
ORDER BY avg_costs DESC;
```

| category | avg_costs |
| :--- | :--- |
| Bikes | 949 |
| Components | 264 |
| n/a | 28 |
| Clothing | 24 |
| Accessories | 13 |


#### Query: Total revenue generated for each category ?


```sql
-- 
SELECT 
    COALESCE(p.category, 'n/a') AS category,
    SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
    ON p.product_key = f.product_key
GROUP BY p.category
ORDER BY total_revenue DESC;
```

| category | total_revenue |
| :--- | :--- |
| Bikes | 28,316,272 |
| Accessories | 700,262 |
| Clothing | 339,716 |




#### Query: Distribution of sold items across countries ?


```sql
-- 
SELECT 
    COALESCE(c.country, 'n/a') AS country,
    SUM(f.quantity) AS total_sold_items
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
    ON c.customer_key = f.customer_key
GROUP BY c.country
ORDER BY total_sold_items DESC;
```

| country | total_sold_items |
| :--- | :--- |
| United States | 20,481 |
| Australia | 13,346 |
| Canada | 7,630 |
| United Kingdom | 6,910 |
| Germany | 5,626 |
| France | 5,559 |
| n/a | 871 |



#### Query: Find total products by category ?


```sql
-- 
SELECT 
    category,
    COUNT(product_key) AS total_products
FROM gold.dim_products
GROUP BY category
ORDER BY total_products DESC;
```

| category | total_products |
| :--- | :--- |
| Components | 127 |
| Bikes | 97 |
| Clothing | 35 |
| Accessories | 29 |
| NULL | 7 |





## 🚀 How to Run

Execute the following terminal commands to clone the repository and run the end-to-end data pipeline:

```bash
# Clone and enter the repository
git clone [https://github.com/Md-Refat-Hosain/sql-data-warehouse-project.git](https://github.com/Md-Refat-Hosain/sql-data-warehouse-project.git)
cd sql-data-warehouse-project

# Execute Medallion architecture transformation scripts
psql -U postgres -d sales_dwh -f scripts/01_bronze_layer.sql
psql -U postgres -d sales_dwh -f scripts/02_silver_layer.sql
psql -U postgres -d sales_dwh -f scripts/03_gold_layer.sql

# Run quality validation checks
psql -U postgres -d sales_dwh -f tests/data_quality_checks.sql
```
