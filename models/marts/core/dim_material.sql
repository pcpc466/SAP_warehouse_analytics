select
    m.material_number,
    mk.material_description,
    m.material_type,
    m.material_group,
    m.industry_sector,
    m.base_unit,
    m.gross_weight,
    m.net_weight,
    m.weight_unit,
    m.created_date
from {{ ref('stg_mara') }} m
left join {{ ref('stg_makt') }} mk
    on m.material_number = mk.material_number
    and mk.language_key = 'E'
