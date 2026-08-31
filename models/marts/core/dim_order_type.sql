select distinct order_type, order_reason
from {{ ref('stg_vbak') }}
where order_type is not null
