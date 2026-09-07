-- Creating and configuring the Warehouse
CREATE WAREHOUSE IF NOT EXISTS SAP_WH
WITH WAREHOUSE_SIZE = 'XSMALL'
AUTO_SUSPEND = 60 
AUTO_RESUME = TRUE 
INITIALLY_SUSPENDED  = TRUE 
COMMENT = 'Warehouse for SAP Data ingestion';

--USE warehouse 
USE WAREHOUSE SAP_WH; 

-- CREATE database 
CREATE DATABASE IF NOT EXISTS SAP_DB 
COMMENT = 'Database for SAP data layers';

-- USE database 
USE DATABASE SAP_DB;

-- Creating Schemas
-- Raw ingestion layer for data loading 
CREATE SCHEMA IF NOT EXISTS RAW 
COMMENT = 'Raw landing layer for SAP data tables';

-- Staging Schemas 
CREATE SCHEMA IF NOT EXISTS STAGING 
COMMENT = 'Staging layer';

-- Analytical Layer for data modeling and Data Marts
CREATE SCHEMA IF NOT EXISTS ANALYTICS 
COMMENT = 'Analytics layer for business-ready dimensional modeling';

-- Dropping public schemas for structural clarity. 
DROP SCHEMA IF EXISTS SAP_DB.PUBLIC;

-- Checking 
SHOW WAREHOUSES LIKE 'SAP_WH';
SHOW SCHEMAS IN DATABASE SAP_DB;

-- Set Active context 
USE WAREHOUSE SAP_WH;
USE DATABASE SAP_DB;
USE SCHEMA RAW;

-- Create a csv file format for SAP extracts

CREATE OR REPLACE FILE FORMAT SAP_CSV_FORMAT 
TYPE = 'CSV'
PARSE_HEADER = TRUE
FIELD_DELIMITER = ','
-- SKIP_HEADER = 1 
PARSE_HEADER = TRUE
FIELD_OPTIONALLY_ENCLOSED_BY = '"'
NULL_IF = ('NULL', 'null', '');

-- Create internal Stage for raw stagging csv

CREATE OR REPLACE STAGE SAP_RAW_STAGE
FILE_FORMAT = SAP_CSV_FORMAT;

// Uploaded files and checking them before ingestion 
LIST @SAP_DB.RAW.SAP_RAW_STAGE;




