select
    trim(mandt)                                               as client_id,
    ltrim(ebeln, '0')                                         as po_number,
    trim(bukrs)                                               as company_code,
    trim(bstyp)                                               as doc_category,
    trim(bsart)                                               as doc_type,
    trim(statu)                                               as status,
    try_to_date(aedat, 'YYYY-MM-DD')                          as changed_on,
    try_to_date(bedat, 'YYYY-MM-DD')                          as po_created_on,
    trim(ernam)                                               as created_by,
    ltrim(lifnr, '0')                                         as vendor_id,
    trim(waers)                                               as currency,
    trim(ekorg)                                               as purchasing_org,
    trim(ekgrp)                                               as purchasing_group
from {{ source('raw_sap', 'EKKO') }}
