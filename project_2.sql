--- 1. Số lượng đơn hàng và số lượng khách hàng mỗi tháng 
SELECT 
  created_date,
  COUNT(DISTINCT user_id) AS total_users,
  COUNT(order_id) AS total_orders
FROM 
  (
    SELECT 
      a.user_id, 
      a.order_id,
      FORMAT_TIMESTAMP('%Y-%m', TIMESTAMP(a.created_at)) AS created_date
    FROM 
      bigquery-public-data.thelook_ecommerce.orders AS a
    JOIN 
      bigquery-public-data.thelook_ecommerce.order_items AS b
    ON 
      a.order_id = b.order_id
    WHERE 
      b.status = 'Complete'
    GROUP BY 
      a.order_id, a.user_id, a.created_at
  ) AS subquery
WHERE created_date BETWEEN '2019-01' AND '2022-04'
GROUP BY 
  created_date
ORDER BY 
  created_date;

/*Insight: Nhìn chung trong khoảng thời gian từ 1/2019-4/2022, số lượng đơn hàng và số lượng khách hàng có sự tăng trưởng đều, mặc dù vẫn có những sự biến động trong quá trình tăng trưởng 
(ví dụ sự giảm đột ngột từ 2021-07 đến 2021-08)*/

--- 2. Giá trị đơn hàng trung bình và số người dùng khác nhau mỗi tháng
SELECT 
  created_date,
  COUNT(DISTINCT user_id) AS distinct_users, 
  ROUND(SUM(total_price) / COUNT(order_id), 2) AS average_order_value 
FROM (
  SELECT 
    user_id, 
    order_id,
    SUM(sale_price) AS total_price, 
    FORMAT_TIMESTAMP('%Y-%m', TIMESTAMP(created_at)) AS created_date 
  FROM 
    bigquery-public-data.thelook_ecommerce.order_items
  WHERE 
    FORMAT_TIMESTAMP('%Y-%m', TIMESTAMP(created_at)) BETWEEN '2019-01' AND '2022-04'
  GROUP BY 
    user_id, created_date, order_id
) AS subquery
GROUP BY 
  created_date
ORDER BY 
  created_date;

/*Insight: - Số lượng người dùng có sự tăng trưởng đều đặn và mạnh mẽ trong khoảng thời gian từ 2019-01 đến 2022-04, có sự giảm nhẹ ở 2022-03 đến 2022-04
           - Giá trị đơn hàng trung bình dao động trong suốt khoảng thời gian. Đến tháng 3/2022, giá trị đơn hàng trung bình giảm xuống mức thấp nhất là 81.1 */


--- 3. Nhóm khách hàng theo độ tuổi

CREATE TABLE my_dataset.temp_customers AS
WITH combined_customers AS (
    -- Youngest customers
    SELECT 
        first_name, 
        last_name, 
        gender, 
        age, 
        'youngest' AS tag
    FROM `bigquery-public-data.thelook_ecommerce.users`
    WHERE created_at BETWEEN '2019-01-01' AND '2022-04-30'
    AND age = (
        SELECT MIN(age)
        FROM `bigquery-public-data.thelook_ecommerce.users` AS c
        WHERE c.gender = `bigquery-public-data.thelook_ecommerce.users`.gender
        AND c.created_at BETWEEN '2019-01-01' AND '2022-04-30'
    )
    
    UNION ALL
    
    -- Oldest customers
    SELECT 
        first_name, 
        last_name, 
        gender, 
        age, 
        'oldest' AS tag
    FROM `bigquery-public-data.thelook_ecommerce.users`
    WHERE created_at BETWEEN '2019-01-01' AND '2022-04-30'
    AND age = (
        SELECT MAX(age)
        FROM `bigquery-public-data.thelook_ecommerce.users` AS c
        WHERE c.gender = `bigquery-public-data.thelook_ecommerce.users`.gender
        AND c.created_at BETWEEN '2019-01-01' AND '2022-04-30'
    )
)
SELECT * FROM combined_customers;

/*Insight: - Lớn nhất là 70 tuổi với 1010 khách hàng
           - Nhỏ nhất là 12 tuổi với 946 khách hàng */


--- 4. Top 5 sản phẩm mỗi tháng
WITH product_sales AS (
    SELECT 
        FORMAT_TIMESTAMP('%Y-%m', TIMESTAMP(o.created_at)) AS month_year,
        o.product_id,
        p.name AS product_name,
        SUM(o.sale_price) AS sales,
        SUM(p.cost) AS cost,
        SUM(o.sale_price - p.cost) AS profit
    FROM 
        `bigquery-public-data.thelook_ecommerce.order_items` AS o
    JOIN 
        `bigquery-public-data.thelook_ecommerce.products` AS p
    ON 
        o.product_id = p.id
    WHERE 
        o.status = 'Complete'
    GROUP BY 
        month_year, o.product_id, p.name
),
ranked_products AS (

    SELECT 
        month_year,
        product_id,
        product_name,
        sales,
        cost,
        profit,
        DENSE_RANK() OVER (PARTITION BY month_year ORDER BY profit DESC) AS rank_per_month
    FROM 
        product_sales
)

SELECT 
    month_year,
    product_id,
    product_name,
    sales,
    cost,
    profit,
    rank_per_month
FROM 
    ranked_products
WHERE 
    rank_per_month <= 5
 
ORDER BY 
    month_year, rank_per_month;


--- 5. Doanh thu tính đến thời điểm hiện tại trên mỗi doanh mục

WITH recent_sales AS (
    SELECT 
        o.created_at,
        p.category,
        o.sale_price
    FROM 
        bigquery-public-data.thelook_ecommerce.order_items AS o
    JOIN 
        bigquery-public-data.thelook_ecommerce.products AS p
    ON 
        o.product_id = p.id
    WHERE 
        o.created_at BETWEEN '2022-01-15' AND '2022-04-14'
        AND o.status = 'Complete'
)
SELECT 
    FORMAT_TIMESTAMP('%Y-%m-%d', TIMESTAMP(created_at)) AS dates,
    category AS product_categories,
    SUM(sale_price) AS revenue
FROM 
    recent_sales
GROUP BY 
    dates, product_categories
ORDER BY 
    dates, product_categories;












