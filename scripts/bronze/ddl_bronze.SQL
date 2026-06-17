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



--DWH project by - DWB

-- 1. Empty the table

CREATE OR REPLACE PROCEDURE bronze.load_bronze()
LANGUAGE plpgsql
AS $$

DECLARE
    -- Total batch execution variables 
    batch_start_time TIMESTAMP;
    batch_end_time   TIMESTAMP;
    
    -- Individual table execution variables 
    step_start_time  TIMESTAMP;
    step_end_time    TIMESTAMP;
    duration_secs    INT;


BEGIN


        RAISE NOTICE '==================================================';
        RAISE NOTICE 'Loading Bronze Layer';
        RAISE NOTICE '==================================================';


        RAISE NOTICE '--------------------------------------------------';
        RAISE NOTICE 'Loading CRM Tables';
        RAISE NOTICE '--------------------------------------------------';

        -- 1. Capture the start time of the entire batch
        batch_start_time := clock_timestamp();
        
        -- --- Table 1: crm_cust_info ---
        -- Start Timer for this table
        step_start_time := clock_timestamp();
        
        RAISE NOTICE '>> Truncating Table: bronze.crm_cust_info';

        TRUNCATE TABLE bronze.crm_cust_info;

        RAISE NOTICE '>> Inserting Data Into: bronze.crm_cust_info';
        COPY bronze.crm_cust_info 
        FROM  '/Users/Shared/sql-data-warehouse-project/datasets/source_crm/cust_info.csv'
        WITH (FORMAT CSV, HEADER true, DELIMITER ',');
        -- End Timer and Calculate Duration 
        step_end_time := clock_timestamp();
        duration_secs := EXTRACT(EPOCH FROM (step_end_time - step_start_time))::INT;

        RAISE NOTICE '==================================================';

        RAISE NOTICE 'Total Pipeline Duration: % seconds', duration_secs; 
        RAISE NOTICE '==================================================';

        RAISE NOTICE '>> Load Duration: % seconds', duration_secs; 


        RAISE NOTICE '- - - - - - - - - - - - - - - - - - - - - - - - -';
        ---prd_info

        -- --- Table 2: ---
        -- Start Timer for this table
        step_start_time := clock_timestamp();

        RAISE NOTICE '>> Truncating Table: bronze.crm_prd_info';
        TRUNCATE TABLE bronze.crm_prd_info;

        RAISE NOTICE '>> Inserting Data Into: bronze.crm_prd_info';
        COPY bronze.crm_prd_info 
        FROM  '/Users/Shared/sql-data-warehouse-project/datasets/source_crm/prd_info.csv'
        WITH (FORMAT CSV, HEADER true, DELIMITER ',');
        
        step_end_time := clock_timestamp();
        duration_secs := EXTRACT(EPOCH FROM (step_end_time - step_start_time))::INT;

        RAISE NOTICE '==================================================';

        RAISE NOTICE 'Total Pipeline Duration: % seconds', duration_secs; 
        RAISE NOTICE '==================================================';

        RAISE NOTICE '- - - - - - - - - - - - - - - - - - - - - - - - -';
        --- sales_details

                -- --- Table 3: ---
        -- Start Timer for this table
        step_start_time := clock_timestamp();

        RAISE NOTICE '>> Truncating Table: bronze.crm_sales_details';
        TRUNCATE TABLE bronze.crm_sales_details;

        RAISE NOTICE '>> Inserting Data Into: bronze.crm_sales_details';
        COPY bronze.crm_sales_details 
        FROM  '/Users/Shared/sql-data-warehouse-project/datasets/source_crm/sales_details.csv'
        WITH (FORMAT CSV, HEADER true, DELIMITER ',');

        step_end_time := clock_timestamp();
        duration_secs := EXTRACT(EPOCH FROM (step_end_time - step_start_time))::INT;

        RAISE NOTICE '==================================================';

        RAISE NOTICE 'Total Pipeline Duration: % seconds', duration_secs;
        RAISE NOTICE '==================================================';

        ---- ERP
        RAISE NOTICE '--------------------------------------------------';
        RAISE NOTICE 'Loading ERP Tables';
        RAISE NOTICE '--------------------------------------------------';

        ---- erp_CUST_AZ12
        -- --- Table 4: ---
        -- Start Timer for this table
        step_start_time := clock_timestamp();
        RAISE NOTICE '>> Truncating Table:  bronze.erp_CUST_AZ12';

        TRUNCATE TABLE bronze.erp_CUST_AZ12;

        -- 2. Cleanly load the data directly from your Desktop path
        RAISE NOTICE '>> Inserting Table:  bronze.erp_CUST_AZ12';

        COPY bronze.erp_CUST_AZ12 
        FROM  '/Users/Shared/sql-data-warehouse-project/datasets/source_erp/CUST_AZ12.csv'
        WITH (FORMAT CSV, HEADER true, DELIMITER ',');

        step_end_time := clock_timestamp();
        duration_secs := EXTRACT(EPOCH FROM (step_end_time - step_start_time))::INT;

        RAISE NOTICE '==================================================';

        RAISE NOTICE 'Total Pipeline Duration: % seconds', duration_secs; 
        RAISE NOTICE '==================================================';        

        RAISE NOTICE '- - - - - - - - - - - - - - - - - - - - - - - - -';

        --- LOC_A101
                -- --- Table 5: ---
        -- Start Timer for this table
        step_start_time := clock_timestamp();
        RAISE NOTICE '>> Truncating Table:  bronze.erp_LOC_A101';
        TRUNCATE TABLE bronze.erp_LOC_A101;

        -- 2. Cleanly load the data directly from your Desktop path
        RAISE NOTICE '>> Inserting Table:  bronze.erp_LOC_A101';
        COPY bronze.erp_LOC_A101 
        FROM  '/Users/Shared/sql-data-warehouse-project/datasets/source_erp/LOC_A101.csv'
        WITH (FORMAT CSV, HEADER true, DELIMITER ',');
        
        step_end_time := clock_timestamp();
        duration_secs := EXTRACT(EPOCH FROM (step_end_time - step_start_time))::INT;

        RAISE NOTICE '==================================================';

        RAISE NOTICE 'Total Pipeline Duration: % seconds', duration_secs; 
        RAISE NOTICE '==================================================';        

        --- PX_CAT_G1V2
                        -- --- Table 6: ---
        -- Start Timer for this table
        step_start_time := clock_timestamp();

        RAISE NOTICE '>> Truncating TablePX_CAT_G1V2:  bronze.erp_PX_CAT_G1V2';
        TRUNCATE TABLE bronze.erp_;

        -- 2. Cleanly load the data directly from your Desktop path
        RAISE NOTICE '>> Inserting Table:  bronze.erp_PX_CAT_G1V2';
        COPY bronze.erp_PX_CAT_G1V2 
        FROM  '/Users/Shared/sql-data-warehouse-project/datasets/source_erp/PX_CAT_G1V2.csv'
        WITH (FORMAT CSV, HEADER true, DELIMITER ',');

        step_end_time := clock_timestamp();
        duration_secs := EXTRACT(EPOCH FROM (step_end_time - step_start_time))::INT;

        RAISE NOTICE '==================================================';
        RAISE NOTICE 'Total Pipeline Duration: % seconds', duration_secs; 
        RAISE NOTICE '==================================================';

        RAISE NOTICE '- - - - - - - - - - - - - - - - - - - - - - - - -';


        batch_end_time := clock_timestamp();
        duration_secs  := EXTRACT(EPOCH FROM (batch_end_time - batch_start_time))::INT; 

        RAISE NOTICE '==================================================';

        RAISE NOTICE 'Total Pipeline Duration: % seconds', duration_secs; 
        RAISE NOTICE '==================================================';

    EXCEPTION
        WHEN OTHERS THEN    
            RAISE NOTICE '==================================================';
            RAISE NOTICE 'ERROR OCCURRED DURING LOADING BRONZE LAYER'; 

            RAISE NOTICE 'Error Message Context: %', SQLERRM; 
            RAISE NOTICE '==================================================';

            RAISE EXCEPTION 'Bronze load aborted due to runtime errors.';
END;
$$;
