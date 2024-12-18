-- Join all related tables into a combined view
CREATE VIEW combined_sales_data AS
SELECT 
    sp.opportunity_id,
    sp.deal_stage,
    sp.engage_date,
    sp.close_date,
    sp.close_value,
    sp.sales_agent,
    sp.product,
    sp.account,
    ac.sector AS industry,
    ac.year_established,
    ac.revenue AS account_revenue,
    ac.employees AS employee_count,
    pr.series AS product_series,
    pr.sales_price,
    st.manager AS sales_manager,
    st.regional_office
FROM sales_pipeline sp
JOIN accounts ac ON sp.account = ac.account
JOIN products pr ON sp.product = pr.product
JOIN sales_teams st ON sp.sales_agent = st.sales_agent;

SELECT 
    ac.sector AS industry, 
    SUM(sp.close_value) AS total_revenue
FROM sales_pipeline sp
JOIN accounts ac ON sp.account = ac.account
WHERE sp.deal_stage = 'Won'
GROUP BY ac.sector
ORDER BY total_revenue DESC;

SELECT 
    sp.sales_agent, 
    SUM(CASE WHEN sp.deal_stage = 'Won' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS win_rate
FROM sales_pipeline sp
GROUP BY sp.sales_agent
ORDER BY win_rate DESC;

SELECT 
    sp.opportunity_id,
    DATEDIFF(sp.close_date, sp.engage_date) AS sales_cycle_length
FROM sales_pipeline sp
WHERE sp.deal_stage IN ('Won', 'Lost')
ORDER BY sales_cycle_length DESC;
