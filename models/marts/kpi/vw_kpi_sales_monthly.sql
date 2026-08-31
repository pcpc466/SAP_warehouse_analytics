select
    date_trunc('month', document_date) as order_month,
    sales_org,
    order_type,
    count(distinct sales_doc_id) as order_count,
    sum(net_amount)              as order_value,
    sum(order_quantity)          as order_quantity
from {{ ref('fct_sales_order_item') }}
where document_date is not null
group by 1, 2, 3
