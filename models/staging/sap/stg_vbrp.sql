select
    ltrim(vbeln, '0')                                         as billing_doc_id,
    ltrim(posnr, '0')                                         as billing_item,
    try_cast(replace(trim(fkimg), ',', '') as decimal(13,3))  as billed_quantity,
    trim(vrkme)                                               as sales_unit,
    trim(meins)                                               as base_unit,
    try_cast(replace(trim(netwr), ',', '') as decimal(15,2))  as net_amount,
    ltrim(vgbel, '0')                                         as ref_sales_doc_id,
    ltrim(vgpos, '0')                                         as ref_sales_item,
    ltrim(matnr, '0')                                         as material_number,
    trim(arktx)                                               as item_description,
    trim(werks)                                               as plant
from {{ source('raw_sap', 'VBRP') }}
