-- Uses po_created_on (BEDAT) as the start date, and client_id-scoped join --
-- with the old AEDAT field and unscoped join, ~99% of rows came back
-- negative. See project notes for the full debugging trail.
select
    p.client_id,
    p.po_number,
    p.po_item,
    p.doc_type,
    p.plant,
    p.material_group,
    p.currency,
    p.purchasing_org,
    p.purchasing_group,
    p.po_quantity,
    p.net_price,
    p.line_value,
    month(p.po_created_on)     as po_month,
    dayofweek(p.po_created_on) as po_day_of_week,
    datediff('day', p.po_created_on, inv.posting_date) as cycle_days
from {{ ref('fct_procurement_item') }} p
join {{ ref('fct_ap_invoice_item') }} inv
    on p.client_id = inv.client_id and p.po_number = inv.po_number and p.po_item = inv.po_item
where p.po_created_on is not null
  and inv.posting_date is not null
