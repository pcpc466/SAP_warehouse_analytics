select
    trim(kokrs)                                               as controlling_area,
    ltrim(kostl, '0')                                         as cost_center,
    try_to_date(datbi, 'YYYY-MM-DD')                          as valid_to,
    try_to_date(datab, 'YYYY-MM-DD')                          as valid_from,
    trim(bukrs)                                               as company_code,
    trim(gsber)                                               as business_area,
    trim(kosar)                                               as cost_center_category,
    trim(verak)                                               as responsible_person,
    trim(werks)                                               as plant
from {{ source('raw_sap', 'CSKS') }}
