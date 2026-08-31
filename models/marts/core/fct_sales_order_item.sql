select
    h.sales_doc_id, i.item_number, h.creation_date, h.document_date,
    h.order_type, h.order_reason, h.sales_org, h.created_by,
    i.material_number, i.item_description, i.material_group, i.plant,
    i.order_quantity, i.sales_unit, i.net_amount, i.currency
from {{ ref('stg_vbak') }} h
join {{ ref('stg_vbap') }} i on h.sales_doc_id = i.sales_doc_id
