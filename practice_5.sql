--Bai_tap_1
SELECT a.CONTINENT AS continents , FLOOR(AVG(b.POPULATION)) AS avg_citypopulations
FROM COUNTRY AS a
INNER JOIN CITY AS b
ON a.CODE=b.COUNTRYCODE
GROUP BY a.CONTINENT

--Bai_tap_2
SELECT 
ROUND(CAST(COUNT(b.signup_action) AS DECIMAL)/COUNT(DISTINCT(a.email_id)),2)
FROM emails AS a
LEFT JOIN texts AS b
ON a.email_id = b.email_id
AND signup_action= 'Confirmed'

--Bai_tap_3
SELECT b.age_bucket,
ROUND(100.0 * SUM(CASE WHEN a.activity_type = 'send' THEN a.time_spent ELSE 0 END) / 
                SUM(a.time_spent), 2) AS send_perc,
ROUND(100.0 * SUM(CASE WHEN a.activity_type = 'open' THEN a.time_spent ELSE 0 END) / 
                SUM(a.time_spent), 2) AS open_perc
FROM activities AS a
INNER JOIN age_breakdown AS b
ON a.user_id = b.user_id
WHERE a.activity_type IN ('send', 'open')
GROUP BY b.age_bucket

--Bai_tap_4
SELECT a.customer_id
FROM customer_contracts AS a
INNER JOIN products AS b
ON a.product_id = b.product_id
GROUP BY a.customer_id
HAVING COUNT(DISTINCT b.product_category) = (SELECT COUNT(DISTINCT product_category) FROM products)

--Bai_tap_5
SELECT a.employee_id, a.name, 
COUNT(b.employee_id)AS reports_count,
ROUND(AVG(b.age)) AS average_age
FROM Employees AS a
INNER JOIN Employees AS b
ON a.employee_id=b.reports_to
GROUP BY a.employee_id
ORDER BY a.employee_id


--Bai_tap_6
SELECT a.product_name,
SUM(b.unit) AS unit
FROM Products AS a
INNER JOIN Orders AS b
ON a.product_id = b.product_id
WHERE order_date BETWEEN '2020-02-01' AND '2020-02-29'
GROUP BY a.product_id
HAVING SUM(b.unit) >=100 

--Bai_tap_7
SELECT a.page_id
FROM pages AS a
LEFT JOIN page_likes AS b
ON a.page_id = b.page_id
WHERE b.page_id IS NULL
ORDER BY a.page_id ASC;















































