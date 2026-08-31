select
    trim(mandt)                                               as client_id,
    ltrim(vbeln, '0')                                         as sales_doc_id,
    try_to_date(erdat, 'YYYY-MM-DD')                          as creation_date,
    trim(erzet)                                               as creation_time,
    trim(ernam)                                               as created_by,
    try_to_date(angdt, 'YYYY-MM-DD')                          as quotation_valid_from,
    try_to_date(bnddt, 'YYYY-MM-DD')                          as quotation_valid_to,
    try_to_date(audat, 'YYYY-MM-DD')                          as document_date,
    trim(vbtyp)                                               as sd_doc_category,
    trim(trvog)                                               as transaction_group,
    trim(auart)                                               as order_type,
    trim(augru)                                               as order_reason,
    try_cast(replace(trim(netwr), ',', '') as decimal(15,2))  as net_amount,
    trim(waerk)                                               as currency,
    trim(vkorg)                                               as sales_org
from {{ source('raw_sap', 'VBAK') }}
