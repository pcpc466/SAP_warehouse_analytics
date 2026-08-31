select
    o.sales_doc_id,
    o.item_number,
    o.order_type,
    o.order_reason,
    o.sales_org,
    o.material_group,
    o.currency,
    o.order_quantity,
    o.net_amount,
    month(o.document_date)     as order_month,
    dayofweek(o.document_date) as order_day_of_week,
    datediff('day', o.document_date, b.billing_date) as cycle_days
from {{ ref('fct_sales_order_item') }} o
join {{ ref('fct_billing_item') }} b
    on o.sales_doc_id = b.ref_sales_doc_id and o.item_number = b.ref_sales_item
where o.document_date is not null
  and b.billing_date is not null
  and b.is_cancelled != 'X'
  and datediff('day', o.document_date, b.billing_date) between 0 and 365
