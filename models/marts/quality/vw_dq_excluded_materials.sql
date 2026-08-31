-- Test/placeholder materials found via investigation: ~0.34% of MARA/MAKT
-- rows are seeded test data ("TEST", "Dummy", repeating-digit placeholder
-- IDs). This view is the single, auditable source of truth for what gets
-- excluded and why -- see dim_material_clean, which filters through this.
select distinct
    material_number,
    material_description,
    'Test/placeholder material' as exclusion_reason
from {{ ref('dim_material') }}
where lower(coalesce(material_description, '')) like '%test%'
   or lower(coalesce(material_description, '')) like '%dummy%'
   or lower(coalesce(material_description, '')) like '%sample%'
   or lower(coalesce(material_description, '')) like '%do not use%'
   or lower(coalesce(material_description, '')) in ('zzz', 'xxx', 'n/a', 'na', 'tbd')
   or lower(material_number) like '%test%'
   or lower(material_number) like '%dummy%'
   or lower(material_number) like '%sample%'
   or material_description is null
