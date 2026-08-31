select
    trim(spras)                                               as language_key,
    trim(laiso)                                               as iso_language_code
from {{ source('raw_sap', 'T002') }}
