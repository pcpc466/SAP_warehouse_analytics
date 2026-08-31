{{ config(materialized='table') }}

select
    date_key,
    year(date_key)        as year_num,
    quarter(date_key)     as quarter_num,
    month(date_key)       as month_num,
    monthname(date_key)   as month_name,
    day(date_key)         as day_num,
    dayname(date_key)     as day_name,
    dayofweek(date_key)   as day_of_week,
    weekofyear(date_key)  as week_of_year,
    case when dayofweek(date_key) in (0,6) then true else false end as is_weekend
from (
    select dateadd(day, seq4(), '2015-01-01'::date) as date_key
    from table(generator(rowcount => 5844))
)
