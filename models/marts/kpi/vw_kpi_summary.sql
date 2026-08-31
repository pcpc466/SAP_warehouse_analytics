with sales as (
    select
        sum(ordered_amount) as total_order_value,
        sum(billed_amount)  as total_billed_value,
        sum(open_amount)    as total_open_order_value
    from {{ ref('vw_order_vs_billing') }}
),
proc as (
    select
        sum(po_value)         as total_po_value,
        sum(invoiced_amount)  as total_invoiced_value,
        sum(uninvoiced_value) as total_open_po_value
    from {{ ref('vw_po_vs_invoice') }}
),
cancel as (
    select
        count(*) as total_billing_docs,
        sum(case when is_cancelled = 'X' then 1 else 0 end) as cancelled_docs
    from {{ ref('fct_billing_item') }}
)
select
    s.total_order_value,
    s.total_billed_value,
    s.total_open_order_value,
    round(div0(s.total_billed_value, s.total_order_value) * 100, 1) as fulfillment_rate_pct,
    p.total_po_value,
    p.total_invoiced_value,
    p.total_open_po_value,
    round(div0(p.total_invoiced_value, p.total_po_value) * 100, 1) as match_rate_pct,
    round(div0(c.cancelled_docs, c.total_billing_docs) * 100, 1) as cancellation_rate_pct
from sales s, proc p, cancel c
