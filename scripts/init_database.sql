
-- ==============================================================================
-- PURPOSE: 
-- This script initializes the Data Warehouse environment. It safely drops the 
-- existing database if it exists, creates a fresh 'data_warehouse', and sets 
-- up the architecture layers (Bronze, Silver, Gold) as schemas.
--
-- WARNING: 
-- Running this script will completely DESTROY the existing database 
-- and all of its data. Proceed with caution!
-- ==============================================================================

-- Step 1: Drop the database if it already exists to start fresh
DROP DATABASE IF EXISTS data_warehouse;

-- Step 2: Create the new Data Warehouse database
CREATE DATABASE data_warehouse;

-- ------------------------------------------------------------------------------
-- NOTE: In PostgreSQL, you cannot switch databases midway through a script 
-- using a "USE" command. 
--
-- BEFORE RUNNING THE NEXT STEPS: 
-- You must change your connection in VS Code to target the new 'data_warehouse' database.
-- ------------------------------------------------------------------------------

-- Step 3: Create the Architectural Layer Schemas
CREATE SCHEMA IF NOT EXISTS bronze;
CREATE SCHEMA IF NOT EXISTS silver;
CREATE SCHEMA IF NOT EXISTS gold;
