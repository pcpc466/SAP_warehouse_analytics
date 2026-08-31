select
    trim(mandt)                                               as client_id,
    ltrim(belnr, '0')                                         as invoice_doc_id,
    trim(gjahr)                                               as fiscal_year,
    ltrim(buzei, '0')                                         as invoice_item,
    ltrim(ebeln, '0')                                         as po_number,
    ltrim(ebelp, '0')                                         as po_item,
    ltrim(matnr, '0')                                         as material_number,
    try_cast(replace(trim(wrbtr), ',', '') as decimal(15,2))  as item_amount,
    trim(shkzg)                                               as debit_credit_ind,
    trim(werks)                                               as plant,
    try_cast(replace(trim(menge), ',', '') as decimal(13,3))  as invoice_quantity
from {{ source('raw_sap', 'RSEG') }}
