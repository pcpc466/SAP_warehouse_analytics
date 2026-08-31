-- The dimension every fact/KPI/ML model should join to, not dim_material
-- directly -- this is what filters out the test/placeholder records
-- documented in vw_dq_excluded_materials.
select m.*
from {{ ref('dim_material') }} m
where m.material_number not in (select material_number from {{ ref('vw_dq_excluded_materials') }})
