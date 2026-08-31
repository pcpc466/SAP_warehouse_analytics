select
    ltrim(matnr, '0')                                         as material_number,
    trim(spras)                                               as language_key,
    trim(maktx)                                               as material_description,
    trim(maktg)                                               as material_description_upper
from {{ source('raw_sap', 'MAKT') }}
