select
    s.cost_center,
    s.controlling_area,
    t.short_text,
    t.long_text,
    s.company_code,
    s.business_area,
    s.cost_center_category,
    s.responsible_person,
    s.plant
from {{ ref('stg_csks') }} s
left join {{ ref('stg_cskt') }} t
    on s.cost_center = t.cost_center
   and s.controlling_area = t.controlling_area
   and t.language_key = 'E'
