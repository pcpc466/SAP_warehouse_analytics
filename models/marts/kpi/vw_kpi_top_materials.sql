select
    m.material_number,
    m.material_description,
    sum(o.net_amount)     as revenue,
    sum(o.order_quantity) as quantity_ordered
from {{ ref('fct_sales_order_item') }} o
join {{ ref('dim_material_clean') }} m on o.material_number = m.material_number
group by m.material_number, m.material_description
order by revenue desc
