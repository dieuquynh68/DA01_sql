--Bai_tap_1
SELECT COUNT (DISTINCT company_id) AS duplicate_companies
FROM (SELECT company_id, title, description,
      COUNT(*) AS count
      FROM job_listings
      GROUP BY company_id, title, description) AS job_count_table
WHERE count>1

--Bai_tap_2
SELECT  category, product, total_spend FROM
(SELECT category, product,
SUM(spend) AS total_spend,
RANK() OVER (PARTITION BY category 
      ORDER BY SUM(spend) DESC) AS top
FROM product_spend
WHERE extract(year from transaction_date)= '2022'
GROUP BY category, product
) AS top_products_spend
WHERE top<=2
ORDER BY category,top

--Bai_tap_3
SELECT COUNT(DISTINCT policy_holder_id) AS policy_holder_count
FROM (SELECT policy_holder_id
FROM callers 
GROUP BY policy_holder_id
HAVING COUNT(case_id) >= 3) AS frequent_callers

--Bai_tap_4
SELECT page_id FROM pages
WHERE page_id NOT IN
(SELECT page_id
 FROM page_likes
 WHERE page_id IS NOT NULL)

--Bai_tap_5
SELECT 
  EXTRACT(MONTH FROM this_month.event_date) AS mth, 
  COUNT(DISTINCT this_month.user_id) AS monthly_active_users 
FROM user_actions AS this_month
WHERE EXISTS (
  SELECT last_month.user_id 
  FROM user_actions AS last_month
  WHERE last_month.user_id = this_month.user_id
    AND EXTRACT(MONTH FROM last_month.event_date) =
    EXTRACT(MONTH FROM this_month.event_date - interval '1 month')
)
  AND EXTRACT(MONTH FROM this_month.event_date) = 7
  AND EXTRACT(YEAR FROM this_month.event_date) = 2022
GROUP BY EXTRACT(MONTH FROM this_month.event_date)

--Bai_tap_6
SELECT  SUBSTR(trans_date,1,7) as month,
country, 
COUNT(id) AS trans_count,
SUM(state = 'approved') AS approved_count,
SUM(amount) AS trans_total_amount,
SUM((state = 'approved') * amount) AS approved_total_amount
FROM Transactions
GROUP BY month, country;

--Bai_tap_7
WITH cte AS 
(SELECT product_id, MIN(year) AS minyear FROM Sales 
    GROUP BY product_id )
SELECT s.product_id, s.year AS first_year, s.quantity, s.price 
FROM Sales s
INNER JOIN cte ON cte.product_id = s.product_id  AND s.year = cte.minyear; 

--Bai_tap_8
SELECT customer_id from customer
GROUP BY customer_id
HAVING count( DISTINCT product_key) >= (select count(product_key) from product)

--Bai_tap_9
SELECT employee_id
FROM Employees
WHERE salary < 30000
AND manager_id NOT IN (
  SELECT employee_id FROM Employees
)
ORDER BY employee_id;

--Bai_tap_11
(SELECT Users.name as results
FROM MovieRating left join Users
ON MovieRating.user_id = Users.user_id 
GROUP BY Users.user_id
ORDER BY count(MovieRating.movie_id) desc, Users.name
LIMIT 1) 
UNION ALL
(SELECT Movies.title as results
FROM MovieRating  left join Movies 
ON MovieRating.movie_id = Movies.movie_id
WHERE MovieRating.created_at like '2020-02%'
GROUP BY MovieRating.movie_id
ORDER BY avg(MovieRating.rating) desc, 
        Movies.title 
LIMIT 1)

--Bai_tap_12
WITH base AS (SELECT requester_id id from RequestAccepted
UNION ALL
SELECT accepter_id id FROM RequestAccepted)
SELECT id, count(*) num  from base 
GROUP BY 1 
ORDER BY 2 desc 
LIMIT 1

































