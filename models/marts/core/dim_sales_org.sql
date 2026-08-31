select distinct sales_org
from (
    select sales_org from {{ ref('stg_vbak') }}
    union
    select sales_org from {{ ref('stg_vbrk') }}
)
where sales_org is not null
