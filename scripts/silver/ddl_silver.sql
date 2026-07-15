
/*
================================================================================
DDL Script: Create Silver Tables
================================================================================
Script Purpose:
    This script creates tables in the 'silver' schema, dropping existing tables
    if they already exist.
    Run this script to re-define the DDL structure of 'bronze' Tables
================================================================================
*/

--##--All Tables

DROP TABLE IF EXISTS silver.crm_cust_info;
CREATE TABLE silver.crm_cust_info (
    cst_id             INT,
    cst_key            VARCHAR(50),
    cst_first_name     VARCHAR(50),
    cst_last_name      VARCHAR(50),
    cst_marital_status VARCHAR(50),
    cst_gndr         VARCHAR(50),
    --cst_is_active      INT,
    cst_create_date    TIMESTAMP,
    dwh_create_date TIMESTAMP DEFAULT CLOCK_TIMESTAMP()
);

-- --- Table 2: crm_prd_info [00:08:20] ---
DROP TABLE IF EXISTS silver.crm_prd_info;
CREATE TABLE silver.crm_prd_info (
    prd_id       INT,  
    cat_id       VARCHAR(50),
    prd_key      VARCHAR(50),
    prd_nm       VARCHAR(50),
    prd_cost     NUMERIC,
    prd_line     VARCHAR(50),
    prd_start_dt     DATE,
    prd_end_dt       date,
    dwh_create_date TIMESTAMP DEFAULT CLOCK_TIMESTAMP()
);

-- --- Table 3: crm_sales_details [00:08:23] ---
DROP TABLE IF EXISTS silver.crm_sales_details;
CREATE TABLE silver.crm_sales_details (
    sls_ord_num  VARCHAR(50),
    sls_prd_key  VARCHAR(50),
    sls_cust_id  INT,
    sls_order_dt date,
    sls_ship_dt  date,
    sls_due_dt   date,
    sls_sales    int,
    sls_price    int,
    sls_qty      INT,
    
    dwh_create_date TIMESTAMP DEFAULT CLOCK_TIMESTAMP()
);


-- ==============================================================================
-- SECTION 2: ERP SYSTEM TABLES [00:08:25]
-- ==============================================================================

-- --- Table 4: erp_cust_az12 [00:08:35] ---
DROP TABLE IF EXISTS silver.erp_cust_az12;
CREATE TABLE silver.erp_cust_az12 (
    cid    VARCHAR(50),
    bdate  DATE,
    gen    VARCHAR(50),
    dwh_create_date TIMESTAMP DEFAULT CLOCK_TIMESTAMP()
);

-- --- Table 5: erp_loc_a101 [00:08:35] ---
DROP TABLE IF EXISTS silver.erp_loc_a101;
CREATE TABLE silver.erp_loc_a101 (
    cid    VARCHAR(50),
    cntry  VARCHAR(50),
    dwh_create_date TIMESTAMP DEFAULT CLOCK_TIMESTAMP()
);

-- --- Table 6: erp_px_cat_g1v2 [00:08:35] ---
DROP TABLE IF EXISTS silver.erp_px_cat_g1v2;
CREATE TABLE silver.erp_px_cat_g1v2 (
    id           VARCHAR(50),
    cat          VARCHAR(50),
    subcat       VARCHAR(50),
    maintanace  VARCHAR(50),
    dwh_create_date TIMESTAMP DEFAULT CLOCK_TIMESTAMP()
);
