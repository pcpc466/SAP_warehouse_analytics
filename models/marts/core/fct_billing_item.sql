select
    h.billing_doc_id, i.billing_item, h.billing_date, h.billing_category,
    h.sales_org, h.is_cancelled, h.company_code,
    i.material_number, i.item_description, i.plant,
    i.billed_quantity, i.sales_unit, i.net_amount, h.currency,
    i.ref_sales_doc_id, i.ref_sales_item
from {{ ref('stg_vbrk') }} h
join {{ ref('stg_vbrp') }} i on h.billing_doc_id = i.billing_doc_id
