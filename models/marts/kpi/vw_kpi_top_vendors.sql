select
    vendor_id,
    sum(line_value) as total_spend,
    count(distinct po_number) as po_count,
    round(sum(line_value) * 100.0 / sum(sum(line_value)) over (), 2) as pct_of_total_spend
from {{ ref('fct_procurement_item') }}
group by vendor_id
order by total_spend desc
