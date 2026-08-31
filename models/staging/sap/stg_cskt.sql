select
    trim(spras)                                               as language_key,
    trim(kokrs)                                               as controlling_area,
    ltrim(kostl, '0')                                         as cost_center,
    try_to_date(datbi, 'YYYY-MM-DD')                          as valid_to,
    trim(ktext)                                               as short_text,
    trim(ltext)                                               as long_text
from {{ source('raw_sap', 'CSKT') }}
