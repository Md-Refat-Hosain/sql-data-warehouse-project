/*

-- ==============================================================================
PURPOSE: DDL Script to define the schema structure for the Bronze Layer.
DESCRIPTION: This script checks for existing tables and recreates them cleanly.
              It covers 3 tables from the CRM system and 3 from the ERP system.
 LAYER: Bronze (Raw Data Ingestion Staging Area)
 Naming Convention: bronze.<source_system>_<table_name> [00:06:40]
==============================================================================

==============================================================================
SECTION 1: CRM SYSTEM TABLES [00:08:17]
==============================================================================


*/

DROP TABLE IF EXISTS bronze.crm_cust_info;
CREATE TABLE bronze.crm_cust_info (
    id             INT,
    key            VARCHAR(50),
    first_name     VARCHAR(50),
    last_name      VARCHAR(50),
    marital_status VARCHAR(50),
    gender         VARCHAR(50),
    is_active      INT,
    create_date    TIMESTAMP
);

-- --- Table 2: crm_prd_info [00:08:20] ---
DROP TABLE IF EXISTS bronze.crm_prd_info;
CREATE TABLE bronze.crm_prd_info (
    prd_id       INT,
    prd_key      VARCHAR(50),
    prd_nm       VARCHAR(50),
    prd_cost     NUMERIC,
    prd_line     VARCHAR(50),
    start_dt     TIMESTAMP,
    end_dt       TIMESTAMP
);

-- --- Table 3: crm_sales_details [00:08:23] ---
DROP TABLE IF EXISTS bronze.crm_sales_details;
CREATE TABLE bronze.crm_sales_details (
    sls_ord_num  VARCHAR(50),
    sls_prd_key  VARCHAR(50),
    sls_cust_id  INT,
    sls_order_dt TIMESTAMP,
    sls_ship_dt  TIMESTAMP,
    sls_due_dt   TIMESTAMP,
    sls_sales    NUMERIC,
    sls_qty      INT,
    sls_price    NUMERIC
);


-- ==============================================================================
-- SECTION 2: ERP SYSTEM TABLES [00:08:25]
-- ==============================================================================

-- --- Table 4: erp_cust_az12 [00:08:35] ---
DROP TABLE IF EXISTS bronze.erp_cust_az12;
CREATE TABLE bronze.erp_cust_az12 (
    cid    VARCHAR(50),
    bdate  DATE,
    gen    VARCHAR(50)
);

-- --- Table 5: erp_loc_a101 [00:08:35] ---
DROP TABLE IF EXISTS bronze.erp_loc_a101;
CREATE TABLE bronze.erp_loc_a101 (
    cid    VARCHAR(50),
    cntry  VARCHAR(50)
);

-- --- Table 6: erp_px_cat_g1v2 [00:08:35] ---
DROP TABLE IF EXISTS bronze.erp_px_cat_g1v2;
CREATE TABLE bronze.erp_px_cat_g1v2 (
    id           VARCHAR(50),
    cat          VARCHAR(50),
    subcat       VARCHAR(50),
    maintenance  VARCHAR(50)
);
