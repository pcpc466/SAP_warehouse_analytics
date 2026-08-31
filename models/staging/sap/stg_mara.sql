select
    ltrim(matnr, '0')                                         as material_number,
    try_to_date(ersda, 'YYYY-MM-DD')                          as created_date,
    trim(ernam)                                               as created_by,
    try_to_date(laeda, 'YYYY-MM-DD')                          as last_changed_date,
    trim(mtart)                                               as material_type,
    trim(mbrsh)                                               as industry_sector,
    trim(matkl)                                               as material_group,
    trim(meins)                                               as base_unit,
    try_cast(replace(trim(brgew), ',', '') as decimal(13,3))  as gross_weight,
    try_cast(replace(trim(ntgew), ',', '') as decimal(13,3))  as net_weight,
    trim(gewei)                                               as weight_unit
from {{ source('raw_sap', 'MARA') }}
