select
    o.sales_doc_id, o.item_number, o.material_number, o.order_quantity,
    o.net_amount as ordered_amount, o.currency,
    coalesce(sum(b.billed_quantity), 0) as billed_quantity,
    coalesce(sum(b.net_amount), 0)      as billed_amount,
    o.net_amount - coalesce(sum(b.net_amount), 0) as open_amount
from {{ ref('fct_sales_order_item') }} o
left join {{ ref('fct_billing_item') }} b
    on o.sales_doc_id = b.ref_sales_doc_id and o.item_number = b.ref_sales_item
   and b.is_cancelled != 'X'
group by o.sales_doc_id, o.item_number, o.material_number, o.order_quantity, o.net_amount, o.currency
