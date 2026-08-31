select
    trim(mandt)                                               as client_id,
    ltrim(vbeln, '0')                                         as billing_doc_id,
    trim(fkart)                                               as billing_type,
    trim(fktyp)                                               as billing_category,
    trim(vbtyp)                                               as sd_doc_category,
    trim(waerk)                                               as currency,
    trim(vkorg)                                               as sales_org,
    try_to_date(fkdat, 'YYYY-MM-DD')                          as billing_date,
    ltrim(belnr, '0')                                         as accounting_doc_id,
    trim(gjahr)                                               as fiscal_year,
    try_cast(replace(trim(netwr), ',', '') as decimal(15,2))  as net_amount,
    trim(fksto)                                               as is_cancelled,
    ltrim(kunag, '0')                                         as sold_to_party,
    trim(bukrs)                                               as company_code
from {{ source('raw_sap', 'VBRK') }}
