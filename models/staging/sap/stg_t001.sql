select
    trim(bukrs)                                               as company_code,
    trim(butxt)                                               as company_name,
    trim(ort01)                                               as city,
    trim(land1)                                               as country,
    trim(waers)                                               as currency,
    trim(spras)                                               as language_key
from {{ source('raw_sap', 'T001') }}
