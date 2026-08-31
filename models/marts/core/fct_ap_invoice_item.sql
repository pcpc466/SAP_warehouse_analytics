select
    h.client_id, h.invoice_doc_id, h.fiscal_year, i.invoice_item, h.document_date,
    h.posting_date, h.vendor_id, h.currency, h.gross_amount as header_gross_amount,
    h.company_code, i.po_number, i.po_item, i.material_number,
    i.item_amount, i.debit_credit_ind, i.plant
from {{ ref('stg_rbkp') }} h
join {{ ref('stg_rseg') }} i
    on h.client_id = i.client_id and h.invoice_doc_id = i.invoice_doc_id and h.fiscal_year = i.fiscal_year
