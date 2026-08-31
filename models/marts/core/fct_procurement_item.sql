-- client_id joined on both keys -- PO_NUMBER is only unique WITHIN a
-- client (this dataset has 3: MANDT 050/100/250). Without this, invoice
-- items can match against unrelated POs from a different client that
-- happen to share the same number.
select
    h.client_id, h.po_number, i.po_item, h.changed_on, h.po_created_on, h.doc_type, h.status,
    i.company_code, i.plant, i.storage_location, i.material_number,
    i.material_group, i.po_quantity, i.unit_of_measure, i.net_price,
    round(i.po_quantity * i.net_price, 2) as line_value,
    h.vendor_id, h.currency, h.created_by, h.purchasing_org, h.purchasing_group
from {{ ref('stg_ekko') }} h
join {{ ref('stg_ekpo') }} i on h.client_id = i.client_id and h.po_number = i.po_number
