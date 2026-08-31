select distinct currency
from (
    select currency from {{ ref('stg_vbak') }}
    union
    select currency from {{ ref('stg_ekko') }}
    union
    select currency from {{ ref('stg_rbkp') }}
)
where currency is not null
