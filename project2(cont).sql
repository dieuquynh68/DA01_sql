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
    bigquery-public-data.thelook_ecommerce.orders AS a
  JOIN 
    bigquery-public-data.thelook_ecommerce.order_items AS b
    ON a.order_id = b.order_id
  JOIN 
    bigquery-public-data.thelook_ecommerce.products AS c
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
WITH cte AS (
  SELECT 
        user_id, 
        order_id,
        sale_price,
        FORMAT_TIMESTAMP('%Y-%m', TIMESTAMP(created_at)) AS cohort_date,
        created_at,
        (EXTRACT(YEAR FROM created_at) - EXTRACT(YEAR FROM first_purchase_date)) * 12 + 
        (EXTRACT(MONTH FROM created_at) - EXTRACT(MONTH FROM first_purchase_date)) + 1 AS cohort_index
    FROM (
        SELECT 
            user_id, 
            order_id,
            sale_price,
            MIN(created_at) OVER(PARTITION BY user_id) AS first_purchase_date,
            created_at
        FROM 
            bigquery-public-data.thelook_ecommerce.order_items
    ) AS subquery
),

xxx AS (
    SELECT 
        cohort_date,
        cohort_index,
        COUNT(DISTINCT user_id) AS user_count,
        SUM(sale_price) AS revenue
    FROM 
        cte
    WHERE cohort_index <= 4 
    GROUP BY 
        cohort_date, 
        cohort_index
),

cte2 AS( 
SELECT 
    cohort_date,
    SUM(CASE WHEN cohort_index = 1 THEN user_count ELSE 0 END) AS m1,
    SUM(CASE WHEN cohort_index = 2 THEN user_count ELSE 0 END) AS m2,
    SUM(CASE WHEN cohort_index = 3 THEN user_count ELSE 0 END) AS m3,
    SUM(CASE WHEN cohort_index = 4 THEN user_count ELSE 0 END) AS m4
FROM 
    xxx
GROUP BY 
    cohort_date
ORDER BY 
    cohort_date)

SELECT cohort_date,
round(100.00* m1/m1,2)||'%' AS m1,
round(100.00*m2/m1,2)||'%' AS m2,
round(100.00*m3/m1,2)||'%' AS m3,
round(100.00*m4/m1,2)||'%' AS m4
FROM cte2

/*Insight: 
- Trong khoảng thời gian từ 2019-01 đến 2024-08, có sự tăng trưởng rõ rệt trong tỉ lệ khách hàng quay lại sau các tháng sử dụng dịch vụ. 
Điều này thể hiện sự cải thiện tổng thể trong việc giữ chân khách hàng qua từng năm. 

- Từ năm 2024, tỉ lệ khách hàng quay lại tăng hơn các năm trước đó (8.02% vào m2 2024-02). 
Nguyên nhân có thể do sự tăng lên trong hiệu quả sản phẩm, dịch vụ khách hàng hay những chiến dịch marketing thành công.

- Có vẻ như các chiến dịch marketing gần đây đang đóng vai trò quan trọng trong việc thu hút và giữ chân khách hàng. 
Vì vậy, marketing team nên tổ chức nhiều chiến dịch hơn nữa hướng tới target customer (theo độ tuổi, hay giới tính).

- Ngoài việc mở rộng các chiến dịch marketing, việc tiếp tục cải thiện chất lượng sản phẩm và dịch vụ là 
cần thiết để duy trì mức độ hài lòng và tăng cường sự quay lại của khách hàng.*/







