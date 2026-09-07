import streamlit as st
import pandas as pd
from snowflake.snowpark.context import get_active_session

# Set page configuration
# Display local image
# st.image("saplogo.png", caption="Incoming Quality Check", use_container_width=True)
st.set_page_config(page_title="Executive Analytics Dashboard", layout="wide")
# CSS injection 

st.markdown("""
    <style>
    /* Main Background & Text */
    .stApp {
        background-color: #181816;
        color: #ECEAE2;
    }
    
    /* Headers & Subheaders */
    h1, h2, h3, h4 {
        color: #F4F3EE !important;
        font-family: 'Sohne', 'Segoe UI', sans-serif;
    }

    /* Metric Cards Styling */
    [data-testid="stMetric"] {
        background-color: #22221F;
        border: 1px solid #343430;
        padding: 16px;
        border-radius: 10px;
    }
    
    [data-testid="stMetricValue"] {
        color: #D97757 !important;
    }

    /* Tabs Styling */
    button[data-baseweb="tab"] {
        color: #C2C0B6 !important;
    }
    
    button[aria-selected="true"] {
        color: #D97757 !important;
        border-bottom-color: #D97757 !important;
    }

    /* Streamlit DataFrame & Table Dark Theme Styling */
    [data-testid="stDataFrame"], .stDataFrame {
        background-color: #22221F !important;
        border: 1px solid #343430 !important;
        border-radius: 8px !important;
    }

    /* DataFrame Headers */
    [data-testid="stDataFrame"] iframe {
        color-scheme: dark !important;
    }

    /* Expander Container */
    [data-testid="stExpander"] {
        background-color: #22221F !important;
        border: 1px solid #343430 !important;
        border-radius: 8px !important;
    }
    </style>
""", unsafe_allow_html=True)

# Replace line 68 with this layout block:
col_logo, col_title = st.columns([1, 8])

with col_logo:
    st.image(
        "https://upload.wikimedia.org/wikipedia/commons/5/59/SAP_2011_logo.svg",
        width=120
    )

with col_title:
    st.title("Warehoouse Analytics Dashboard")

# Get active Snowflake session
session = get_active_session()

# Create tabs for different business domains
tab1, tab2 = st.tabs(["💰 Sales & Revenue", "📦 Operations & Procurment"])

# ==============================================================================
# TAB 1: SALES & REVENUE PERFORMANCE
# ==============================================================================
with tab1:
    st.header("Sales Performance & Profitability")
    
    # 1. Total Sales KPI
    q1 = "SELECT SUM(ITEM_NET_AMOUNT) AS TOTAL_SALES FROM SAP_DB.ANALYTICS.FACT_SALES_ORDERS;"
    df_sales = session.sql(q1).to_pandas()
    total_sales_val = df_sales['TOTAL_SALES'].iloc[0] or 0
    
    st.metric("Total Sales Revenue", f"${total_sales_val:,.2f}")
    st.divider()

    col1, col2 = st.columns(2)

    with col1:
        st.subheader("MoM Sales Trend")
        # 3. Month over Month Sales
        q3 = """
            WITH MONTHLY_SALES AS ( 
                SELECT 
                    DATE_TRUNC('month', ORDER_DATE) AS SALES_MONTH, 
                    SUM(ITEM_NET_AMOUNT) AS TOTAL_SALES,
                    LAG(SUM(ITEM_NET_AMOUNT)) OVER (ORDER BY DATE_TRUNC('month', ORDER_DATE)) AS LAST_MONTH_SALES
                FROM SAP_DB.ANALYTICS.FACT_SALES_ORDERS 
                WHERE ORDER_DATE IS NOT NULL 
                GROUP BY 1
            ) 
            SELECT 
                TO_VARCHAR(SALES_MONTH, 'YYYY-MM') AS MONTH_OF_SALE,
                TOTAL_SALES,
                LAST_MONTH_SALES,
                ROUND((TOTAL_SALES - LAST_MONTH_SALES), 2) AS MOM_DIFFERENCE, 
                ROUND(((TOTAL_SALES - LAST_MONTH_SALES) / NULLIF(LAST_MONTH_SALES, 0)) * 100, 2) AS MOM_GROWTH_PERC
            FROM MONTHLY_SALES
            WHERE LAST_MONTH_SALES IS NOT NULL
            ORDER BY MONTH_OF_SALE ASC;
        """
        df_mom = session.sql(q3).to_pandas()
        st.line_chart(df_mom, x="MONTH_OF_SALE", y="TOTAL_SALES", color = "#D97757")
        with st.expander("View MoM Data Table"):
            st.dataframe(df_mom, width="stretch")

    with col2:
        st.subheader("Top Product Categories by Sales")
        # 2. Sales by Category
        q2 = """
            SELECT M.MATERIAL_GROUP, 
                   SUM(F.ITEM_NET_AMOUNT) AS TOTAL_SALES
            FROM SAP_DB.ANALYTICS.FACT_SALES_ORDERS F 
            LEFT JOIN SAP_DB.ANALYTICS.DIM_MATERIAL M ON F.PRODUCT_ID = M.MATERIAL_NUMBER
            WHERE F.ITEM_NET_AMOUNT IS NOT NULL
            GROUP BY 1
            ORDER BY 2 DESC
            LIMIT 10;
        """
        df_cat = session.sql(q2).to_pandas()
        st.bar_chart(df_cat, x="MATERIAL_GROUP", y="TOTAL_SALES",color="#D97757" )

        st.divider()
    st.subheader("Top 20 Products by Profit Margin %")

    q_margin = """
    WITH product_margin AS (
        SELECT 
            S.MATERIAL_NUMBER, 
            M.MATERIAL_DESCRIPTION AS PRODUCT_NAME, 
            ROUND(SUM(S.NET_AMOUNT), 2) AS TOTAL_REVENUE, 
            ROUND(SUM(S.ORDER_QUANTITY) * AVG(C.NET_PRICE)) AS TOTAL_COST
        FROM SAP_DB.ANALYTICS.FCT_SALES_ORDER_ITEM S
        JOIN SAP_DB.ANALYTICS.DIM_MATERIAL_CLEAN M 
            ON S.MATERIAL_NUMBER = M.MATERIAL_NUMBER
        JOIN SAP_DB.ANALYTICS.FCT_PROCUREMENT_ITEM C 
            ON S.MATERIAL_NUMBER = C.MATERIAL_NUMBER AND S.CURRENCY = C.CURRENCY
        WHERE M.MATERIAL_DESCRIPTION IS NOT NULL
        GROUP BY S.MATERIAL_NUMBER, M.MATERIAL_DESCRIPTION
    )
    SELECT 
        PRODUCT_NAME, 
        ROUND((TOTAL_REVENUE - TOTAL_COST) / NULLIF(TOTAL_REVENUE, 0) * 100, 2) AS P_MARGIN_PCT
    FROM product_margin
    WHERE TOTAL_REVENUE > 0
    AND ROUND((TOTAL_REVENUE - TOTAL_COST) / NULLIF(TOTAL_REVENUE, 0) * 100, 2) BETWEEN 0 AND 100
    ORDER BY P_MARGIN_PCT DESC
    LIMIT 20;
    """

    df_margin = session.sql(q_margin).to_pandas()

    # Vertical bar chart (default orientation)
    st.bar_chart(
        df_margin, 
        x="PRODUCT_NAME", 
        y="P_MARGIN_PCT", 
        horizontal=True,
        color="#D97757"
    )

#==============================================================================
# TAB 2: OPERATIONS & SUPPLY CHAIN
# ==============================================================================
with tab2:
    st.header("Operations, Procurement & Supply Chain")

    # --- SECTION 1: Order Fulfillment & Replenishment ---
    st.subheader("Order Fulfillment & Replenishment Rate")
    
    # 4. Fulfillment Rate Query & Metrics
    q4 = """
    SELECT 
        COUNT(BILLING_ITEM) AS TOTAL_ORDER_PLACED,
        COUNT(CASE WHEN IS_CANCELLED = 'X' THEN BILLING_ITEM END) AS CANCELLED_ORDER,
        ROUND(((COUNT(BILLING_ITEM) - COUNT(CASE WHEN IS_CANCELLED = 'X' THEN BILLING_ITEM END)) * 100.0 / NULLIF(COUNT(BILLING_ITEM), 0)), 2) AS REPLENISHMENT_RATE
    FROM SAP_DB.ANALYTICS.FCT_BILLING_ITEM;
    """
    df_ful = session.sql(q4).to_pandas()
    placed = df_ful['TOTAL_ORDER_PLACED'].iloc[0] or 0
    cancelled = df_ful['CANCELLED_ORDER'].iloc[0] or 0
    rate = df_ful['REPLENISHMENT_RATE'].iloc[0] or 0.0

    st.metric("Replenishment Rate", f"{rate}%")
    st.write(f"**Total Orders Placed:** {placed:,}")
    st.write(f"**Cancelled Orders:** {cancelled:,}")

    st.divider()

    # --- SECTION 2: Procure-to-Pay Lead Time ---
    st.subheader("Procure-to-Pay Lead Time (Days)")
    
    # 5. Procure to Pay Days Distribution
    q5 = """
    SELECT 
        I.PO_NUMBER, 
        I.PO_ITEM, 
        PO.CHANGED_ON AS PO_DATE, 
        I.POSTING_DATE AS INVOICE_DATE,
        DATEDIFF('day', PO.CHANGED_ON, I.POSTING_DATE) AS PRO2PAY_DAYS
    FROM SAP_DB.ANALYTICS.FCT_AP_INVOICE_ITEM I
    LEFT JOIN SAP_DB.ANALYTICS.FCT_PROCUREMENT_ITEM PO 
        ON PO.PO_NUMBER = I.PO_NUMBER AND PO.PO_ITEM = I.PO_ITEM
    WHERE PO.CHANGED_ON IS NOT NULL 
      AND DATEDIFF('day', PO.CHANGED_ON, I.POSTING_DATE) BETWEEN 0 AND 365
    ORDER BY INVOICE_DATE;
    """
    df_p2p = session.sql(q5).to_pandas()
    st.scatter_chart(df_p2p, x="INVOICE_DATE", y="PRO2PAY_DAYS", color="#E2B93B")

    # --- KPI DISPLAY RIGHT UNDER CHART ---
    avg_p2p = df_p2p["PRO2PAY_DAYS"].mean() if not df_p2p.empty else 0.0
    st.metric("Avg Procure-to-Pay Lead Time", f"{avg_p2p:.1f} Days")

    with st.expander("View Raw Match Data"):
        st.dataframe(df_p2p, width="stretch")

    st.divider()

    # --- SECTION 3: Procurement Spend & Vendor Risk ---
    st.subheader("Top 10 Vendor Concentration")
    
    # 7. Vendor Concentration
    q7 = """
    WITH TOP_VENDORS AS (
        SELECT 
            VENDOR_ID, 
            SUM(LINE_VALUE) AS VENDOR_COST
        FROM SAP_DB.ANALYTICS.FCT_PROCUREMENT_ITEM
        WHERE VENDOR_ID IS NOT NULL 
          AND VENDOR_ID NOT LIKE '%TEST' 
          AND LINE_VALUE IS NOT NULL
        GROUP BY 1
        ORDER BY 2 DESC
        LIMIT 10
    ),
    TOTAL_COST AS (
        SELECT SUM(LINE_VALUE) AS GRAND_COST 
        FROM SAP_DB.ANALYTICS.FCT_PROCUREMENT_ITEM
    )
    SELECT 
        V.VENDOR_ID, 
        V.VENDOR_COST, 
        ROUND((V.VENDOR_COST / C.GRAND_COST) * 100, 2) AS PCT_OF_COST
    FROM TOP_VENDORS V 
    CROSS JOIN TOTAL_COST C
    ORDER BY PCT_OF_COST DESC;
    """
    df_vendor = session.sql(q7).to_pandas()
    
    v_col1, v_col2 = st.columns([3, 2])
    with v_col1:
        st.bar_chart(df_vendor, x="VENDOR_ID", y="PCT_OF_COST", color="#E2B93B", use_container_width=True)


   