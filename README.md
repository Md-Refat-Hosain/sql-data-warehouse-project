


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

#### 🌐 Customer Distribution by Country

```sql
-- Query: Total customer count grouped by country
SELECT 
    COALESCE(country, 'n/a') AS country,
    COUNT(customer_key) AS total_customers
FROM gold.dim_customers
GROUP BY country
ORDER BY total_customers DESC;


![Image Description](https://github.com/Md-Refat-Hosain/sql-data-warehouse-project/blob/ddfed3c495394032c7747ec0e0bf215412b92bc7/image/analysis_images/s.png?raw=true)

### 2

![Image Description](https://github.com/Md-Refat-Hosain/sql-data-warehouse-project/blob/ddfed3c495394032c7747ec0e0bf215412b92bc7/image/analysis_images/s1.png?raw=true)


### 3

![Image Description](https://github.com/Md-Refat-Hosain/sql-data-warehouse-project/blob/ddfed3c495394032c7747ec0e0bf215412b92bc7/image/analysis_images/s2.png?raw=true)



