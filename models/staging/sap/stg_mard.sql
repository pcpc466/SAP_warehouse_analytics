select
    ltrim(matnr, '0')                                         as material_number,
    trim(werks)                                               as plant,
    trim(lgort)                                               as storage_location,
    try_cast(replace(trim(labst), ',', '') as decimal(13,3))  as unrestricted_stock,
    try_cast(replace(trim(insme), ',', '') as decimal(13,3))  as quality_inspection_stock,
    try_cast(replace(trim(speme), ',', '') as decimal(13,3))  as blocked_stock
from {{ source('raw_sap', 'MARD') }}
