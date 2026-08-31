select
    trim(kurst)                                               as exchange_rate_type,
    trim(fcurr)                                               as from_currency,
    trim(tcurr)                                               as to_currency,
    try_to_date(gdatu, 'YYYYMMDD')                            as valid_from_date,
    try_cast(replace(trim(ukurs), ',', '') as decimal(13,6))  as exchange_rate
from {{ source('raw_sap', 'TCURR') }}
