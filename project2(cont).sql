---1,
WITH sales_data AS (
  SELECT
    EXTRACT(MONTH FROM a.created_at) AS Month,
    EXTRACT(YEAR FROM a.created_at) AS Year,
    c.category AS product_category,
    SUM(b.sale_price) AS TPV, 
    COUNT(DISTINCT b.order_id) AS TPO, 
    SUM(c.cost) AS Total_cost, 
    SUM(b.sale_price) - SUM(c.cost) AS Total_profit 
  FROM 
    `bigquery-public-data.thelook_ecommerce.orders` AS a
  JOIN 
    `bigquery-public-data.thelook_ecommerce.order_items` AS b
    ON a.order_id = b.order_id
  JOIN 
    `bigquery-public-data.thelook_ecommerce.products` AS c
    ON b.product_id = c.id
  GROUP BY 
    Month, Year, c.category
),

vw_ecommerce_analyst AS (
  SELECT 
    Month,
    Year,
    product_category,
    TPV,
    TPO,
    Total_cost,
    Total_profit,
    100*(TPV - LAG(TPV) OVER (PARTITION BY product_category ORDER BY Year, Month)) / LAG(TPV) OVER (PARTITION BY product_category ORDER BY Year, Month)||'%' AS revenue_growth,  
    100*(TPO - LAG(TPO) OVER (PARTITION BY product_category ORDER BY Year, Month)) / LAG(TPO) OVER (PARTITION BY product_category ORDER BY Year, Month)||'%' AS order_growth,
    Total_profit / Total_cost AS Profit_to_cost_ratio
  FROM 
    sales_data
)

SELECT *
FROM vw_ecommerce_analyst;

---2, Retention cohort analysis














