# 🏭 SAP Warehouse Analytics with Snowflake

An end-to-end data warehouse and analytics platform built on a synthetic SAP ECC-style **Order-to-Cash (O2C)** and **Procure-to-Pay (P2P)** dataset — ingested and modeled in ❄️ Snowflake, transformed with 🛠️ dbt Cloud, version-controlled on 🐙 GitHub, and visualized in a native 📊 Streamlit dashboard.

---

## 📌 Overview

- **Source data:** Synthetic SAP ECC-style export (Google Cloud training platform) — 16 tables across Sales, Procurement, and Master Data
- **Warehouse:** Snowflake, layered as `RAW → STAGING → ANALYTICS`
- **Transformation:** dbt Cloud project (staging models, marts, tests, docs)
- **Visualization:** Streamlit dashboard, deployed natively inside Snowflake
- **Version control:** GitHub, connected directly to dbt Cloud

---

## 🧱 Architecture

```
RAW          → typed landing tables (COPY INTO + MATCH_BY_COLUMN_NAME)
STAGING      → cleaned, typed, business-renamed views
ANALYTICS    → star/constellation schema (4 facts, 9 dims, reconciliation + KPI views)
```

Each layer builds only on the one before it — a fix in `STAGING` flows automatically into every dashboard and KPI downstream. 🔄

---

## 🔤 From Cryptic SAP Codes → Readable Names

SAP's raw field codes are decades-old and unreadable outside an SAP shop. The staging layer translates every one:

| Raw SAP Field | Business Name | Meaning |
|---|---|---|
| `MANDT` | `CLIENT_ID` | SAP client / tenant |
| `VBELN` | `SALES_DOC_ID` | Sales order number |
| `EBELN` | `PO_NUMBER` | Purchase order number |
| `LIFNR` | `VENDOR_ID` | Vendor / supplier ID |
| `MATNR` | `MATERIAL_NUMBER` | Product / SKU ID |
| `NETWR` | `NET_AMOUNT` | Net transaction value |
| `BEDAT` | `PO_CREATED_ON` | True PO creation date |

---

## 🐛 Key Bugs Found & Fixed

- 🧩 **Column-position mismatch** — 100–300+ source columns vs. 9–15 defined; fixed with `MATCH_BY_COLUMN_NAME` + `PARSE_HEADER`
- 📅 **Wrong cycle-time field** — `AEDAT` (last-changed) swapped for `BEDAT` (true creation date), fixing negative cycle times
- 🔑 **Cross-client ID collisions** — 3 SAP clients (`MANDT` 050/100/250) reuse the same numbering; every join re-scoped by `CLIENT_ID`
- 🧪 **Embedded test data** — ~0.34% seeded placeholder records (`TEST`, `Dummy`) isolated via a dedicated data-quality view

---

## 🛠️ dbt Cloud + GitHub

- 16 staging models, 13 marts, KPI views — all built with `ref()`/`source()` lineage
- ✅ Declarative tests (`not_null`, `unique`, composite-key checks) replacing manual audit queries
- 📖 Auto-generated documentation and dependency graph
- 🔗 Connected directly to GitHub — every fix is a traceable commit, not a silent change

---

## 📊 Dashboard Highlights

| Metric | Value |
|---|---|
| 💰 Total Sales Revenue | **$19.17B** |
| 📦 Order Replenishment Rate | **99.08%** |
| 🛒 Total Orders Placed | **232,361** |
| ❌ Cancelled Orders | **2,132** |
| ⏱️ Avg. Procure-to-Pay Lead Time | **14.7 days** |

Built as a two-tab Streamlit app running **natively inside Snowflake** — no external hosting, no credential juggling.

---

## 💡 Business Impact

- 📈 **Replenishment rate** → early-warning signal for stockout risk
- 🚩 **Cancellations** → segment by org/type/time to find the real cause
- 🤝 **P2P lead time** → benchmark vendors, flag renegotiation candidates
- 🔍 **Revenue spikes** → separate real demand events from data-quality artifacts
- 🎯 **Margin ranking** → focus promotion on high-margin, not just high-volume, products

---

## ✅ Deliverables

- [x] 🗺️ Star/constellation schema ERD (draw.io-importable)
- [x] 🧾 Full SQL scripts — RAW, STAGING, ANALYTICS
- [x] 🛠️ dbt Cloud project (staging + marts + tests + docs), GitHub-connected
- [x] 📊 Interactive Streamlit dashboard, deployed in Snowflake
- [x] 📄 1-page (now 2-page 😄) project summary

---

## 📂 Repo Structure

```
├── snowflake_sql/       # hand-built RAW → STAGING → ANALYTICS SQL
├── dbt_sap_dwh/         # dbt Cloud project (staging + marts)
└── README.md            # you are here 👋
```

---

Built with ❄️ Snowflake, 🛠️ dbt, and a lot of 🐛 bug-hunting.
