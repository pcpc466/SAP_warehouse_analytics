-- Degenerate dimension -- no vendor master (LFA1) was provided in this dataset
select distinct vendor_id
from (
    select vendor_id from {{ ref('stg_ekko') }}
    union
    select vendor_id from {{ ref('stg_rbkp') }}
)
where vendor_id is not null
