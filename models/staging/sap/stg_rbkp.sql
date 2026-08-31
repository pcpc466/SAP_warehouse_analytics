select
    trim(mandt)                                               as client_id,
    ltrim(belnr, '0')                                         as invoice_doc_id,
    trim(gjahr)                                               as fiscal_year,
    trim(blart)                                               as doc_type,
    try_to_date(bldat, 'YYYY-MM-DD')                          as document_date,
    try_to_date(budat, 'YYYY-MM-DD')                          as posting_date,
    try_to_date(cpudt, 'YYYY-MM-DD')                          as entry_date,
    trim(usnam)                                               as created_by,
    ltrim(lifnr, '0')                                         as vendor_id,
    trim(waers)                                               as currency,
    try_cast(replace(trim(rmwwr), ',', '') as decimal(15,2))  as gross_amount,
    trim(bukrs)                                               as company_code
from {{ source('raw_sap', 'RBKP') }}
