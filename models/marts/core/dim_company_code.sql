select
    company_code,
    company_name,
    city,
    country,
    currency as home_currency
from {{ ref('stg_t001') }}
