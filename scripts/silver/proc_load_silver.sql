/*
================================================================================
Stored Procedure: Load Silver Layer (Bronze -> Silver)
================================================================================
Script Purpose:
    This stored procedure performs the ETL (Extract, Transform, Load) process to
    populate the 'silver' schema tables from the 'bronze' schema.
    Actions Performed:
    - Truncates Silver tables.
    - Inserts transformed and cleansed data from Bronze into Silver tables.

Parameters:
    None.
    This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC Silver.load_silver;
================================================================================
*/


CREATE OR REPLACE PROCEDURE silver.load_silver()
LANGUAGE plpgsql
AS $$
DECLARE
    batch_start_time TIMESTAMP;
    batch_end_time   TIMESTAMP;
    step_start_time  TIMESTAMP;
    step_end_time    TIMESTAMP;
    duration_secs    INT;
BEGIN
    batch_start_time := clock_timestamp();

    RAISE NOTICE '==================================================';
    RAISE NOTICE 'Starting Silver Layer Load (Cleanse & Transform)';
    RAISE NOTICE '==================================================';

    -- ==========================================================================
    -- SECTION 1: CRM TABLES
    -- ==========================================================================
    RAISE NOTICE '--------------------------------------------------';
    RAISE NOTICE 'Loading CRM Tables';
    RAISE NOTICE '--------------------------------------------------';

    -- --- Table 1: silver.crm_cust_info (Corrected & Deduplicated) ---
    step_start_time := clock_timestamp();
    RAISE NOTICE '>> Truncating Table: silver.crm_cust_info';
    TRUNCATE TABLE silver.crm_cust_info;
    
    RAISE NOTICE '>> Transforming and Inserting Data into: silver.crm_cust_info';
    INSERT INTO silver.crm_cust_info (
        cst_id, cst_key, cst_firstname, cst_lastname, 
        cst_marital_status, cst_gndr, cst_create_date
    )
    SELECT 
        cst_id,
        TRIM(cst_key),
        TRIM(cst_firstname),
        TRIM(cst_lastname),
        -- Standardizing Marital Status (handling NULLs/typos)
        CASE WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
             WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
             ELSE 'n/a'
        END ,
        -- Standardizing Gender
        CASE WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
             WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
             ELSE 'n/a'
        END,
        cst_create_date
    FROM (
        SELECT 
            id AS cst_id,
            key AS cst_key,
            first_name AS cst_firstname,
            last_name AS cst_lastname,
            marital_status AS cst_marital_status,
            gender AS cst_gndr,
            create_date::DATE AS cst_create_date,
            ROW_NUMBER() OVER (PARTITION BY id ORDER BY create_date DESC) as flag_last
        FROM bronze.crm_cust_info
        WHERE id IS NOT NULL
    ) t 
    WHERE flag_last = 1; -- Ensures only the latest unique record per customer is loaded
    
    step_end_time := clock_timestamp();
    duration_secs := EXTRACT(EPOCH FROM (step_end_time - step_start_time))::INT;
    RAISE NOTICE '>> Load Duration: % seconds', duration_secs;

    -- --- Table 2: silver.crm_prd_info ---
    step_start_time := clock_timestamp();
    RAISE NOTICE '>> Truncating Table: silver.crm_prd_info';
    TRUNCATE TABLE silver.crm_prd_info;
    
    RAISE NOTICE '>> Transforming and Inserting Data into: silver.crm_prd_info';
    INSERT INTO silver.crm_prd_info (
        prd_id, cat_id, prd_key, prd_nm, prd_cost, prd_line, prd_start_dt, prd_end_dt
    )
    SELECT 
        prd_id,
        SPLIT_PART(prd_key, '-', 1), 
        TRIM(prd_key),
        TRIM(prd_nm),
        COALESCE(prd_cost, 0), 
        CASE WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
             WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
             WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring'
             WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Standard'
             ELSE 'n/a'
        END,
        start_dt::DATE,
        -- Calculate end date of product lifecycles dynamically using LEAD
        (LEAD(start_dt::DATE) OVER (PARTITION BY prd_key ORDER BY start_dt) - 1)::DATE
    FROM bronze.crm_prd_info;
    
    step_end_time := clock_timestamp();
    duration_secs := EXTRACT(EPOCH FROM (step_end_time - step_start_time))::INT;
    RAISE NOTICE '>> Load Duration: % seconds', duration_secs;

    -- --- Table 3: silver.crm_sales_details ---
    step_start_time := clock_timestamp();
    RAISE NOTICE '>> Truncating Table: silver.crm_sales_details';
    TRUNCATE TABLE silver.crm_sales_details;
    
    RAISE NOTICE '>> Transforming and Inserting Data into: silver.crm_sales_details';
    INSERT INTO silver.crm_sales_details (
        sls_ord_num, sls_prd_key, sls_cust_id, sls_order_dt, 
        sls_ship_dt, sls_due_dt, sls_sales, sls_qty, sls_price
    )
    SELECT 
        sls_ord_num,
        sls_prd_key,
        sls_cust_id,
        case  
            when sls_order_dt = 0 or length(sls_order_dt) != 8 then null
            else cast(cast(sls_order_dt as varchar) as date)
        end as sls_order_dt,
        case  
            when sls_ship_dt = 0 or length(sls_ship_dt) != 8 then null
            else cast(cast(sls_ship_dt as varchar) as date)
        end as sls_ship_dt,

        case  
            when sls_due_dt = 0 or length(sls_due_dt) != 8 then null
            else cast(cast(sls_due_dt as varchar) as date)
        end as sls_due_dt,

        CASE WHEN sls_sales IS NULL OR sls_sales <= 0 or sls_sales != sls_quantity * abs(sls_price)
            then sls_quantity * abs(sls_price)
            ELSE sls_sales 
        END sls_sales,
        sls_quantity,
        case 
            when sls_price is null sls_price <=0 then sls_sales/ nullif(sls_quantity, 0)
            else sls_price
        end sls_price
        
    FROM bronze.crm_sales_details;
    
    step_end_time := clock_timestamp();
    duration_secs := EXTRACT(EPOCH FROM (step_end_time - step_start_time))::INT;
    RAISE NOTICE '>> Load Duration: % seconds', duration_secs;

    -- ==========================================================================
    -- SECTION 2: ERP TABLES
    -- ==========================================================================
    RAISE NOTICE '--------------------------------------------------';
    RAISE NOTICE 'Loading ERP Tables';
    RAISE NOTICE '--------------------------------------------------';

    -- --- Table 4: silver.erp_cust_az12 ---
    step_start_time := clock_timestamp();
    RAISE NOTICE '>> Truncating Table: silver.erp_cust_az12';
    TRUNCATE TABLE silver.erp_cust_az12;
    
    RAISE NOTICE '>> Transforming and Inserting Data into: silver.erp_cust_az12';
    INSERT INTO silver.erp_cust_az12 (cid, bdate, gen)
    SELECT 
        CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid FROM 4 for length(cid)) ELSE cid END cid,
        CASE WHEN bdate::DATE > CURRENT_DATE THEN NULL ELSE bdate::DATE END as bdate, -- Filter out futuristic/impossible birthdates
        CASE WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
             WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
             ELSE 'n/a'
        END
    FROM bronze.erp_cust_az12;
    
    step_end_time := clock_timestamp();
    duration_secs := EXTRACT(EPOCH FROM (step_end_time - step_start_time))::INT;
    RAISE NOTICE '>> Load Duration: % seconds', duration_secs;

    -- --- Table 5: silver.erp_loc_a101 ---
    step_start_time := clock_timestamp();
    RAISE NOTICE '>> Truncating Table: silver.erp_loc_a101';
    TRUNCATE TABLE silver.erp_loc_a101;
    
    RAISE NOTICE '>> Transforming and Inserting Data into: silver.erp_loc_a101';
    INSERT INTO silver.erp_loc_a101 (cid, cntry)
    SELECT 
        replace(cid,'-','') cid,
        CASE WHEN TRIM(cntry) = 'DE'  THEN 'Germany'
             when TRIM(cntry) in ('US' , 'USA') then 'United States'
             when TRIM(cntry) = '' or cntry is null then 'n/a'
             ELSE TRIM(cntry)
        END cntry
    FROM bronze.erp_loc_a101;
    
    step_end_time := clock_timestamp();
    duration_secs := EXTRACT(EPOCH FROM (step_end_time - step_start_time))::INT;
    RAISE NOTICE '>> Load Duration: % seconds', duration_secs;

    -- --- Table 6: silver.erp_px_cat_g1v2 ---
    step_start_time := clock_timestamp();
    RAISE NOTICE '>> Truncating Table: silver.erp_px_cat_g1v2';
    TRUNCATE TABLE silver.erp_px_cat_g1v2;
    
    RAISE NOTICE '>> Transforming and Inserting Data into: silver.erp_px_cat_g1v2';
    INSERT INTO silver.erp_px_cat_g1v2 (id, cat, subcat, maintenance)
    SELECT 
        TRIM(id),
        TRIM(cat),
        TRIM(subcat),
        TRIM(maintenance)
    FROM bronze.erp_px_cat_g1v2;
    
    step_end_time := clock_timestamp();
    duration_secs := EXTRACT(EPOCH FROM (step_end_time - step_start_time))::INT;
    RAISE NOTICE '>> Load Duration: % seconds', duration_secs;

    -- ==========================================================================
    -- BATCH COMPLETION TIMING
    -- ==========================================================================
    batch_end_time := clock_timestamp();
    duration_secs  := EXTRACT(EPOCH FROM (batch_end_time - batch_start_time))::INT;

    RAISE NOTICE '==================================================';
    RAISE NOTICE 'Loading Silver Layer Completed Successfully!';
    RAISE NOTICE 'Total Pipeline Duration: % seconds', duration_secs;
    RAISE NOTICE '==================================================';

EXCEPTION 
    WHEN OTHERS THEN
        RAISE NOTICE '==================================================';
        RAISE NOTICE 'FATAL FAILURE OCCURRED DURING SILVER PIPELINE RUN';
        RAISE NOTICE 'Error Message Context: %', SQLERRM;
        RAISE NOTICE '==================================================';
        RAISE EXCEPTION 'Silver load aborted due to runtime errors.';
END;
$$;
