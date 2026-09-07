
--STAGING LAYER 


USE WAREHOUSE SAP_WH;
USE DATABASE SAP_DB;
CREATE SCHEMA IF NOT EXISTS SAP_DB.STAGING;
USE SCHEMA SAP_DB.STAGING;

-- ============================== O2C ====================================

CREATE OR REPLACE VIEW STAGING.STG_VBAK AS
SELECT
    TRIM(MANDT)                                               AS CLIENT_ID,
    LTRIM(VBELN, '0')                                         AS SALES_DOC_ID,
    TRY_TO_DATE(ERDAT, 'YYYY-MM-DD')                          AS CREATION_DATE, 
    TRIM(ERZET)                                               AS CREATION_TIME,
    TRIM(ERNAM)                                               AS CREATED_BY,
    TRY_TO_DATE(ANGDT, 'YYYY-MM-DD')                          AS QUOTATION_VALID_FROM,
    TRY_TO_DATE(BNDDT, 'YYYY-MM-DD')                          AS QUOTATION_VALID_TO,
    TRY_TO_DATE(AUDAT, 'YYYY-MM-DD')                          AS DOCUMENT_DATE,
    TRIM(VBTYP)                                               AS SD_DOC_CATEGORY,
    TRIM(TRVOG)                                               AS TRANSACTION_GROUP,
    TRIM(AUART)                                               AS ORDER_TYPE,
    TRIM(AUGRU)                                               AS ORDER_REASON,
    TRY_CAST(REPLACE(TRIM(NETWR), ',', '') AS DECIMAL(15,2))  AS NET_AMOUNT, 
    TRIM(WAERK)                                               AS CURRENCY,
    TRIM(VKORG)                                               AS SALES_ORG
FROM RAW.VBAK;

-- SELECT * FROM SAP_DB.STAGING.STG_VBAK
-- LIMIT 100;

CREATE OR REPLACE VIEW STAGING.STG_VBAP AS
SELECT
    LTRIM(VBELN, '0')                                         AS SALES_DOC_ID,
    LTRIM(POSNR, '0')                                         AS ITEM_NUMBER,
    LTRIM(MATNR, '0')                                         AS MATERIAL_NUMBER,
    LTRIM(MATWA, '0')                                         AS ENTERED_MATERIAL,
    LTRIM(PMATN, '0')                                         AS PRICING_MATERIAL,
    TRIM(CHARG)                                               AS BATCH_NUMBER,
    TRIM(MATKL)                                               AS MATERIAL_GROUP,
    TRIM(ARKTX)                                               AS ITEM_DESCRIPTION,
    TRIM(PSTYV)                                               AS ITEM_CATEGORY,
    TRY_CAST(REPLACE(TRIM(NETWR), ',', '') AS DECIMAL(15,2))  AS NET_AMOUNT,
    TRIM(WAERK)                                               AS CURRENCY,
    TRY_CAST(REPLACE(TRIM(KWMENG), ',', '') AS DECIMAL(13,3)) AS ORDER_QUANTITY,
    TRIM(VRKME)                                               AS SALES_UNIT,
    TRIM(WERKS)                                               AS PLANT,
    TRY_CAST(REPLACE(TRIM(NETPR), ',', '') AS DECIMAL(15,2))  AS NET_PRICE,
    
FROM RAW.VBAP;



CREATE OR REPLACE VIEW STAGING.STG_VBRK AS
SELECT
    LTRIM(VBELN, '0')                                         AS BILLING_DOC_ID,
    TRIM(FKART)                                                AS BILLING_TYPE,
    TRIM(FKTYP)                                               AS BILLING_CATEGORY,
    TRIM(VBTYP)                                               AS SD_DOC_CATEGORY,
    TRIM(WAERK)                                               AS CURRENCY,
    TRIM(VKORG)                                               AS SALES_ORG,
    TRY_TO_DATE(FKDAT, 'YYYY-MM-DD')                          AS BILLING_DATE,
    LTRIM(BELNR, '0')                                         AS ACCOUNTING_DOC_ID,
    TRIM(GJAHR)                                               AS FISCAL_YEAR,
    TRY_CAST(REPLACE(TRIM(NETWR), ',', '') AS DECIMAL(15,2))  AS NET_AMOUNT,
    TRIM(FKSTO)                                               AS IS_CANCELLED,
    LTRIM(KUNAG, '0')                                         AS SOLD_TO_PARTY,
    TRIM(BUKRS)                                               AS COMPANY_CODE
FROM RAW.VBRK;

CREATE OR REPLACE VIEW STAGING.STG_VBRP AS
SELECT
    LTRIM(VBELN, '0')                                         AS BILLING_DOC_ID,
    LTRIM(POSNR, '0')                                         AS BILLING_ITEM,
    TRY_CAST(REPLACE(TRIM(FKIMG), ',', '') AS DECIMAL(13,3))  AS BILLED_QUANTITY,
    TRIM(VRKME)                                               AS SALES_UNIT,
    TRIM(MEINS)                                               AS BASE_UNIT,
    TRY_CAST(REPLACE(TRIM(NETWR), ',', '') AS DECIMAL(15,2))  AS NET_AMOUNT,
    LTRIM(VGBEL, '0')                                         AS REF_SALES_DOC_ID,
    LTRIM(VGPOS, '0')                                         AS REF_SALES_ITEM,
    LTRIM(MATNR, '0')                                         AS MATERIAL_NUMBER,
    TRIM(ARKTX)                                               AS ITEM_DESCRIPTION,
    TRIM(WERKS)                                               AS PLANT
FROM RAW.VBRP;

-- ============================== P2P ====================================

CREATE OR REPLACE VIEW STAGING.STG_EKKO AS
SELECT
    LTRIM(EBELN, '0')                                         AS PO_NUMBER,
    TRIM(BUKRS)                                               AS COMPANY_CODE,
    TRIM(BSTYP)                                               AS DOC_CATEGORY,
    TRIM(BSART)                                               AS DOC_TYPE,
    TRIM(STATU)                                               AS STATUS,
    TRY_TO_DATE(AEDAT, 'YYYY-MM-DD')                          AS CHANGED_ON,
    TRIM(ERNAM)                                               AS CREATED_BY,
    LTRIM(LIFNR, '0')                                         AS VENDOR_ID,
    TRIM(WAERS)                                               AS CURRENCY,
    TRIM(EKORG)                                               AS PURCHASING_ORG,
    TRIM(EKGRP)                                               AS PURCHASING_GROUP
FROM RAW.EKKO;

CREATE OR REPLACE VIEW STAGING.STG_EKPO AS
SELECT
    LTRIM(EBELN, '0')                                         AS PO_NUMBER,
    LTRIM(EBELP, '0')                                         AS PO_ITEM,
    LTRIM(MATNR, '0')                                         AS MATERIAL_NUMBER,
    TRIM(BUKRS)                                               AS COMPANY_CODE,
    TRIM(WERKS)                                               AS PLANT,
    TRIM(LGORT)                                               AS STORAGE_LOCATION,
    TRY_CAST(REPLACE(TRIM(MENGE), ',', '') AS DECIMAL(13,3))  AS PO_QUANTITY,
    TRIM(MEINS)                                               AS UNIT_OF_MEASURE,
    TRY_CAST(REPLACE(TRIM(NETPR), ',', '') AS DECIMAL(15,2))  AS NET_PRICE,
    TRIM(MATKL)                                               AS MATERIAL_GROUP
FROM RAW.EKPO;

CREATE OR REPLACE VIEW STAGING.STG_RBKP AS
SELECT
    LTRIM(BELNR, '0')                                         AS INVOICE_DOC_ID,
    TRIM(GJAHR)                                               AS FISCAL_YEAR,
    TRIM(BLART)                                               AS DOC_TYPE,
    TRY_TO_DATE(BLDAT, 'YYYY-MM-DD')                          AS DOCUMENT_DATE,
    TRY_TO_DATE(BUDAT, 'YYYY-MM-DD')                          AS POSTING_DATE,
    TRY_TO_DATE(CPUDT, 'YYYY-MM-DD')                          AS ENTRY_DATE,
    TRIM(USNAM)                                               AS CREATED_BY,
    LTRIM(LIFNR, '0')                                         AS VENDOR_ID,
    TRIM(WAERS)                                               AS CURRENCY,
    TRY_CAST(REPLACE(TRIM(RMWWR), ',', '') AS DECIMAL(15,2))  AS GROSS_AMOUNT,
    TRIM(BUKRS)                                               AS COMPANY_CODE
FROM RAW.RBKP;

CREATE OR REPLACE VIEW STAGING.STG_RSEG AS
SELECT
    LTRIM(BELNR, '0')                                         AS INVOICE_DOC_ID,
    TRIM(GJAHR)                                               AS FISCAL_YEAR,
    LTRIM(BUZEI, '0')                                         AS INVOICE_ITEM,
    LTRIM(EBELN, '0')                                         AS PO_NUMBER,
    LTRIM(EBELP, '0')                                         AS PO_ITEM,
    LTRIM(MATNR, '0')                                         AS MATERIAL_NUMBER,
    TRY_CAST(REPLACE(TRIM(WRBTR), ',', '') AS DECIMAL(15,2))  AS ITEM_AMOUNT,
    TRIM(SHKZG)                                               AS DEBIT_CREDIT_IND,
    TRIM(WERKS)                                               AS PLANT,
    TRY_CAST(REPLACE(TRIM(MENGE), ',', '') AS DECIMAL(13,3))  AS INVOICE_QUANTITY
FROM RAW.RSEG;

-- ============================ MASTER DATA ===============================

CREATE OR REPLACE VIEW STAGING.STG_CSKS AS
SELECT
    TRIM(KOKRS)                                               AS CONTROLLING_AREA,
    LTRIM(KOSTL, '0')                                         AS COST_CENTER,
    TRY_TO_DATE(DATBI, 'YYYY-MM-DD')                          AS VALID_TO,
    TRY_TO_DATE(DATAB, 'YYYY-MM-DD')                          AS VALID_FROM,
    TRIM(BUKRS)                                               AS COMPANY_CODE,
    TRIM(GSBER)                                               AS BUSINESS_AREA,
    TRIM(KOSAR)                                               AS COST_CENTER_CATEGORY,
    TRIM(VERAK)                                               AS RESPONSIBLE_PERSON,
    TRIM(WERKS)                                               AS PLANT
FROM RAW.CSKS;

CREATE OR REPLACE VIEW STAGING.STG_CSKT AS
SELECT
    TRIM(SPRAS)                                               AS LANGUAGE_KEY,
    TRIM(KOKRS)                                               AS CONTROLLING_AREA,
    LTRIM(KOSTL, '0')                                         AS COST_CENTER,
    TRY_TO_DATE(DATBI, 'YYYY-MM-DD')                          AS VALID_TO,
    TRIM(KTEXT)                                               AS SHORT_TEXT,
    TRIM(LTEXT)                                               AS LONG_TEXT
FROM RAW.CSKT;

CREATE OR REPLACE VIEW STAGING.STG_MAKT AS
SELECT
    LTRIM(MATNR, '0')                                         AS MATERIAL_NUMBER,
    TRIM(SPRAS)                                               AS LANGUAGE_KEY,
    TRIM(MAKTX)                                               AS MATERIAL_DESCRIPTION,
    TRIM(MAKTG)                                               AS MATERIAL_DESCRIPTION_UPPER
FROM RAW.MAKT;

CREATE OR REPLACE VIEW STAGING.STG_MARA AS
SELECT
    LTRIM(MATNR, '0')                                         AS MATERIAL_NUMBER,
    TRY_TO_DATE(ERSDA, 'YYYY-MM-DD')                          AS CREATED_DATE,
    TRIM(ERNAM)                                               AS CREATED_BY,
    TRY_TO_DATE(LAEDA, 'YYYY-MM-DD')                          AS LAST_CHANGED_DATE,
    TRIM(MTART)                                               AS MATERIAL_TYPE,
    TRIM(MBRSH)                                               AS INDUSTRY_SECTOR,
    TRIM(MATKL)                                               AS MATERIAL_GROUP,
    TRIM(MEINS)                                               AS BASE_UNIT,
    TRY_CAST(REPLACE(TRIM(BRGEW), ',', '') AS DECIMAL(13,3))  AS GROSS_WEIGHT,
    TRY_CAST(REPLACE(TRIM(NTGEW), ',', '') AS DECIMAL(13,3))  AS NET_WEIGHT,
    TRIM(GEWEI)                                               AS WEIGHT_UNIT
FROM RAW.MARA;

CREATE OR REPLACE VIEW STAGING.STG_MARD AS
SELECT
    LTRIM(MATNR, '0')                                         AS MATERIAL_NUMBER,
    TRIM(WERKS)                                               AS PLANT,
    TRIM(LGORT)                                               AS STORAGE_LOCATION,
    TRY_CAST(REPLACE(TRIM(LABST), ',', '') AS DECIMAL(13,3))  AS UNRESTRICTED_STOCK,
    TRY_CAST(REPLACE(TRIM(INSME), ',', '') AS DECIMAL(13,3))  AS QUALITY_INSPECTION_STOCK,
    TRY_CAST(REPLACE(TRIM(SPEME), ',', '') AS DECIMAL(13,3))  AS BLOCKED_STOCK
FROM RAW.MARD;

CREATE OR REPLACE VIEW STAGING.STG_T001 AS
SELECT
    TRIM(BUKRS)                                               AS COMPANY_CODE,
    TRIM(BUTXT)                                               AS COMPANY_NAME,
    TRIM(ORT01)                                               AS CITY,
    TRIM(LAND1)                                               AS COUNTRY,
    TRIM(WAERS)                                               AS CURRENCY,
    TRIM(SPRAS)                                               AS LANGUAGE_KEY
FROM RAW.T001;

CREATE OR REPLACE VIEW STAGING.STG_T002 AS
SELECT
    TRIM(SPRAS)                                               AS LANGUAGE_KEY,
    TRIM(LAISO)                                               AS ISO_LANGUAGE_CODE
FROM RAW.T002;

CREATE OR REPLACE VIEW STAGING.STG_TCURR AS
SELECT
    TRIM(KURST)                                               AS EXCHANGE_RATE_TYPE,
    TRIM(FCURR)                                               AS FROM_CURRENCY,
    TRIM(TCURR)                                               AS TO_CURRENCY,
    TRY_TO_DATE(GDATU, 'YYYYMMDD')                            AS VALID_FROM_DATE,
    TRY_CAST(REPLACE(TRIM(UKURS), ',', '') AS DECIMAL(13,6))  AS EXCHANGE_RATE
FROM RAW.TCURR;


-- NULL AUDIT -- 

SELECT 'STG_VBAK.NET_AMOUNT' CHK, COUNT(*) `COUNT_ROW, COUNT(NET_AMOUNT) NON_NULL FROM STAGING.STG_VBAK
UNION ALL SELECT 'STG_VBAP.ORDER_QUANTITY', COUNT(*), COUNT(ORDER_QUANTITY) FROM STAGING.STG_VBAP
UNION ALL SELECT 'STG_VBRK.NET_AMOUNT', COUNT(*), COUNT(NET_AMOUNT) FROM STAGING.STG_VBRK
UNION ALL SELECT 'STG_VBRP.NET_AMOUNT', COUNT(*), COUNT(NET_AMOUNT) FROM STAGING.STG_VBRP
UNION ALL SELECT 'STG_EKPO.NET_PRICE', COUNT(*), COUNT(NET_PRICE) FROM STAGING.STG_EKPO
UNION ALL SELECT 'STG_RBKP.GROSS_AMOUNT', COUNT(*), COUNT(GROSS_AMOUNT) FROM STAGING.STG_RBKP
UNION ALL SELECT 'STG_RSEG.ITEM_AMOUNT', COUNT(*), COUNT(ITEM_AMOUNT) FROM STAGING.STG_RSEG
UNION ALL SELECT 'STG_MARA.MATERIAL_NUMBER', COUNT(*), COUNT(MATERIAL_NUMBER) FROM STAGING.STG_MARA;


-- Dates confirmed as YYYY-MM-DD in the source (not YYYYMMDD -- that was
-- the bug in the original build). Numerics are plain decimals with no
-- thousands separator in this dataset, but REPLACE(...,',','') is kept
-- as a defensive habit in case future loads introduce them.
-- =========================================================================
-- DBT Core bugs handling during the testing 
-- =========================================================================

CREATE OR REPLACE VIEW STAGING.STG_VBAP AS
SELECT
    TRIM(MANDT)                                               AS CLIENT_ID,
    LTRIM(VBELN, '0')                                         AS SALES_DOC_ID,
    LTRIM(POSNR, '0')                                         AS ITEM_NUMBER,
    LTRIM(MATNR, '0')                                         AS MATERIAL_NUMBER,
    LTRIM(MATWA, '0')                                         AS ENTERED_MATERIAL,
    LTRIM(PMATN, '0')                                         AS PRICING_MATERIAL,
    TRIM(CHARG)                                               AS BATCH_NUMBER,
    TRIM(MATKL)                                               AS MATERIAL_GROUP,
    TRIM(ARKTX)                                               AS ITEM_DESCRIPTION,
    TRIM(PSTYV)                                               AS ITEM_CATEGORY,
    TRY_CAST(REPLACE(TRIM(NETWR), ',', '') AS DECIMAL(15,2))  AS NET_AMOUNT,
    TRIM(WAERK)                                               AS CURRENCY,
    TRY_CAST(REPLACE(TRIM(KWMENG), ',', '') AS DECIMAL(13,3)) AS ORDER_QUANTITY,
    TRIM(VRKME)                                               AS SALES_UNIT,
    TRIM(WERKS)                                               AS PLANT,
    TRY_CAST(REPLACE(TRIM(NETPR), ',', '') AS DECIMAL(15,2))  AS NET_PRICE
FROM RAW.VBAP;
 
CREATE OR REPLACE VIEW STAGING.STG_VBRP AS
SELECT
    TRIM(MANDT)                                               AS CLIENT_ID,
    LTRIM(VBELN, '0')                                         AS BILLING_DOC_ID,
    LTRIM(POSNR, '0')                                         AS BILLING_ITEM,
    TRY_CAST(REPLACE(TRIM(FKIMG), ',', '') AS DECIMAL(13,3))  AS BILLED_QUANTITY,
    TRIM(VRKME)                                               AS SALES_UNIT,
    TRIM(MEINS)                                               AS BASE_UNIT,
    TRY_CAST(REPLACE(TRIM(NETWR), ',', '') AS DECIMAL(15,2))  AS NET_AMOUNT,
    LTRIM(VGBEL, '0')                                         AS REF_SALES_DOC_ID,
    LTRIM(VGPOS, '0')                                         AS REF_SALES_ITEM,
    LTRIM(MATNR, '0')                                         AS MATERIAL_NUMBER,
    TRIM(ARKTX)                                               AS ITEM_DESCRIPTION,
    TRIM(WERKS)                                               AS PLANT
FROM RAW.VBRP;
 
CREATE OR REPLACE VIEW STAGING.STG_T001 AS
SELECT
    TRIM(MANDT)                                               AS CLIENT_ID,
    TRIM(BUKRS)                                               AS COMPANY_CODE,
    TRIM(BUTXT)                                               AS COMPANY_NAME,
    TRIM(ORT01)                                               AS CITY,
    TRIM(LAND1)                                               AS COUNTRY,
    TRIM(WAERS)                                               AS CURRENCY,
    TRIM(SPRAS)                                               AS LANGUAGE_KEY
FROM RAW.T001;
 
CREATE OR REPLACE VIEW STAGING.STG_MARA AS
SELECT
    TRIM(MANDT)                                               AS CLIENT_ID,
    LTRIM(MATNR, '0')                                         AS MATERIAL_NUMBER,
    TRY_TO_DATE(ERSDA, 'YYYY-MM-DD')                          AS CREATED_DATE,
    TRIM(ERNAM)                                               AS CREATED_BY,
    TRY_TO_DATE(LAEDA, 'YYYY-MM-DD')                          AS LAST_CHANGED_DATE,
    TRIM(MTART)                                               AS MATERIAL_TYPE,
    TRIM(MBRSH)                                               AS INDUSTRY_SECTOR,
    TRIM(MATKL)                                               AS MATERIAL_GROUP,
    TRIM(MEINS)                                               AS BASE_UNIT,
    TRY_CAST(REPLACE(TRIM(BRGEW), ',', '') AS DECIMAL(13,3))  AS GROSS_WEIGHT,
    TRY_CAST(REPLACE(TRIM(NTGEW), ',', '') AS DECIMAL(13,3))  AS NET_WEIGHT,
    TRIM(GEWEI)                                               AS WEIGHT_UNIT
FROM RAW.MARA;
 
CREATE OR REPLACE VIEW STAGING.STG_MAKT AS
SELECT
    TRIM(MANDT)                                               AS CLIENT_ID,
    LTRIM(MATNR, '0')                                         AS MATERIAL_NUMBER,
    TRIM(SPRAS)                                               AS LANGUAGE_KEY,
    TRIM(MAKTX)                                               AS MATERIAL_DESCRIPTION,
    TRIM(MAKTG)                                               AS MATERIAL_DESCRIPTION_UPPER
FROM RAW.MAKT;

CREATE OR REPLACE VIEW STAGING.STG_VBRK AS
SELECT
    TRIM(MANDT)                                               AS CLIENT_ID,
    LTRIM(VBELN, '0')                                         AS BILLING_DOC_ID,
    TRIM(FKART)                                                AS BILLING_TYPE,
    TRIM(FKTYP)                                               AS BILLING_CATEGORY,
    TRIM(VBTYP)                                               AS SD_DOC_CATEGORY,
    TRIM(WAERK)                                               AS CURRENCY,
    TRIM(VKORG)                                               AS SALES_ORG,
    TRY_TO_DATE(FKDAT, 'YYYY-MM-DD')                          AS BILLING_DATE,
    LTRIM(BELNR, '0')                                         AS ACCOUNTING_DOC_ID,
    TRIM(GJAHR)                                               AS FISCAL_YEAR,
    TRY_CAST(REPLACE(TRIM(NETWR), ',', '') AS DECIMAL(15,2))  AS NET_AMOUNT,
    TRIM(FKSTO)                                               AS IS_CANCELLED,
    LTRIM(KUNAG, '0')                                         AS SOLD_TO_PARTY,
    TRIM(BUKRS)                                               AS COMPANY_CODE
FROM RAW.VBRK;
 
-- -------------------------------------------------------------------------
-- Rebuild the ANALYTICS objects that depend on these, with client_id
-- now included in every join condition
-- -------------------------------------------------------------------------
