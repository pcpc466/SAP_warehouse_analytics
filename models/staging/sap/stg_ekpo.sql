select
    trim(mandt)                                               as client_id,
    ltrim(ebeln, '0')                                         as po_number,
    ltrim(ebelp, '0')                                         as po_item,
    ltrim(matnr, '0')                                         as material_number,
    trim(bukrs)                                               as company_code,
    trim(werks)                                               as plant,
    trim(lgort)                                               as storage_location,
    try_cast(replace(trim(menge), ',', '') as decimal(13,3))  as po_quantity,
    trim(meins)                                               as unit_of_measure,
    try_cast(replace(trim(netpr), ',', '') as decimal(15,2))  as net_price,
    trim(matkl)                                               as material_group
from {{ source('raw_sap', 'EKPO') }}
