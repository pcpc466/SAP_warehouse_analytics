select
    date_trunc('month', po_created_on) as po_month,
    plant,
    count(distinct po_number) as po_count,
    sum(line_value)           as po_value
from {{ ref('fct_procurement_item') }}
where po_created_on is not null
group by 1, 2
