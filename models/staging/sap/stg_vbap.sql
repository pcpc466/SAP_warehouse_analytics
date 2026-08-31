select
    ltrim(vbeln, '0')                                         as sales_doc_id,
    ltrim(posnr, '0')                                         as item_number,
    ltrim(matnr, '0')                                         as material_number,
    ltrim(matwa, '0')                                         as entered_material,
    ltrim(pmatn, '0')                                         as pricing_material,
    trim(charg)                                               as batch_number,
    trim(matkl)                                               as material_group,
    trim(arktx)                                               as item_description,
    trim(pstyv)                                               as item_category,
    try_cast(replace(trim(netwr), ',', '') as decimal(15,2))  as net_amount,
    trim(waerk)                                               as currency,
    try_cast(replace(trim(kwmeng), ',', '') as decimal(13,3)) as order_quantity,
    trim(vrkme)                                               as sales_unit,
    trim(werks)                                               as plant,
    try_cast(replace(trim(netpr), ',', '') as decimal(15,2))  as net_price
from {{ source('raw_sap', 'VBAP') }}
