select
    p.client_id, p.po_number, p.po_item, p.material_number, p.po_quantity,
    p.line_value as po_value, p.currency,
    coalesce(sum(inv.item_amount), 0) as invoiced_amount,
    p.line_value - coalesce(sum(inv.item_amount), 0) as uninvoiced_value
from {{ ref('fct_procurement_item') }} p
left join {{ ref('fct_ap_invoice_item') }} inv
    on p.client_id = inv.client_id and p.po_number = inv.po_number and p.po_item = inv.po_item
group by p.client_id, p.po_number, p.po_item, p.material_number, p.po_quantity, p.line_value, p.currency
