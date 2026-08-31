# sap_dwh — dbt project

dbt transformation layer for the SAP O2C/P2P Snowflake warehouse. Converts the
hand-written STAGING and ANALYTICS SQL views into dbt models with `ref()`/
`source()` lineage, built-in testing, and auto-generated documentation.

## What this replaces

This project sits on top of the SAME raw tables built by `01_raw_load_all.sql` —
dbt does not load data, it only transforms what's already in `SAP_DB.RAW`.

| Old (raw SQL) | New (dbt) |
|---|---|
| `02_staging_views_all.sql` | `models/staging/sap/stg_*.sql` |
| `03_analytics_layer_v2.sql` | `models/marts/core/*.sql` |
| `04_kpi_views_v2.sql` | `models/marts/kpi/*.sql` |
| `05_ml_training_views.sql` | `models/marts/ml/*.sql` |
| `06_data_quality_exclusions.sql` | `models/marts/quality/*.sql` + `dim_material_clean` |
| Manual null-audit `SELECT COUNT(...)` queries | dbt's built-in `tests:` (see `_sap__staging.yml`, `_core__marts.yml`) |

All bug fixes from the debugging process are already baked in here:
- `MATCH_BY_COLUMN_NAME` + `PARSE_HEADER` (in the RAW load, unchanged)
- `po_created_on` (BEDAT) instead of `changed_on` (AEDAT) for cycle time
- `client_id`-scoped joins on the P2P side to prevent cross-client PO number collisions
- `dim_material_clean` filtering out test/placeholder materials

## Project structure

```
models/
  staging/sap/       -- 1:1 with RAW tables, typed + cleaned, views
    _sap__sources.yml -- points dbt at SAP_DB.RAW
    _sap__staging.yml -- docs + tests
    stg_*.sql
  marts/
    core/             -- dimensions, facts, reconciliation views
    kpi/              -- KPI views for the dashboard
    ml/               -- ML training data views
    quality/          -- data quality exclusion lists
```

## Setting up dbt Cloud

1. Push this whole `dbt_sap_dwh/` folder to a GitHub repo (see your GitHub
   deliverable — same repo, or a subfolder of it).
2. Sign up for dbt Cloud free tier: https://www.getdbt.com/signup
3. Create a new project, connect it to:
   - **Your GitHub repo** (dbt Cloud will ask for repo access)
   - **Your Snowflake account** — same account/warehouse/database you've
     been using, but point dbt at a dedicated schema for its own output
     (e.g. `DBT_DEV`) rather than writing directly into `STAGING`/`ANALYTICS`.
     This keeps your hand-built objects and dbt's generated objects separate
     while you're learning both.
4. In **Deploy → Environments**, set:
   - Database: `SAP_DB`
   - Warehouse: `SAP_WH`
   - Schema: `DBT_DEV` (or your preference)
5. Open the dbt Cloud IDE, run:
   ```
   dbt run
   ```
   This builds every model in dependency order automatically — staging
   first, then marts, since dbt reads the `ref()` calls to build the DAG.
6. Run tests:
   ```
   dbt test
   ```
   This replaces every manual `SELECT COUNT(*) WHERE ... IS NULL` audit
   query from the raw SQL build with a real, repeatable test suite.
7. Generate docs:
   ```
   dbt docs generate
   dbt docs serve
   ```
   This produces an interactive, browsable version of the same lineage
   your ERD diagram shows — auto-generated from the `ref()` graph, not
   hand-drawn.

## Local development (optional, alternative to dbt Cloud)

```bash
pip install dbt-snowflake
cp profiles.yml.example ~/.dbt/profiles.yml   # fill in your credentials
dbt debug   # verify connection
dbt run
dbt test
```

## Why dbt over raw SQL views

- **Lineage is automatic.** `ref('stg_vbak')` inside `fct_sales_order_item.sql`
  tells dbt the dependency — no manual "run these in this order" instructions.
- **Tests are declarative**, not one-off queries you have to remember to re-run.
- **Docs are generated**, not maintained by hand in a README.
- **Environments are separated** — dev/staging/prod target different schemas
  from the same codebase, instead of hand-editing `CREATE OR REPLACE VIEW`
  statements each time.

The underlying SQL logic is identical to the raw-SQL version — this is a
restructuring for maintainability, not a rewrite of the business logic.
