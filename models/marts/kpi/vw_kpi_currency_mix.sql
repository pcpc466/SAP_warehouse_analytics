select currency, sum(net_amount) as total_value
from {{ ref('fct_sales_order_item') }}
group by currency
order by total_value desc
