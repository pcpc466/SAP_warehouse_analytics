-- Uses po_created_on (BEDAT), not changed_on (AEDAT) -- see stg_ekko notes.
-- client_id-scoped joins to avoid cross-client PO number collisions.
select
    'Order to Bill' as process,
    round(avg(datediff('day', o.document_date, b.billing_date)), 1) as avg_cycle_days
from {{ ref('fct_sales_order_item') }} o
join {{ ref('fct_billing_item') }} b
    on o.sales_doc_id = b.ref_sales_doc_id and o.item_number = b.ref_sales_item
where o.document_date is not null and b.billing_date is not null
union all
select
    'PO to Invoice' as process,
    round(avg(datediff('day', p.po_created_on, inv.posting_date)), 1) as avg_cycle_days
from {{ ref('fct_procurement_item') }} p
join {{ ref('fct_ap_invoice_item') }} inv
    on p.client_id = inv.client_id and p.po_number = inv.po_number and p.po_item = inv.po_item
where p.po_created_on is not null and inv.posting_date is not null
