---Bai_tap_1
SELECT DISTINCT CITY from STATION
WHERE ID%2 = 0
ORDER BY CITY ASC

---Bai_tap_2
SELECT
COUNT(CITY) - COUNT(DISTINCT CITY) 
FROM STATION

---Bai_tap_3
SELECT CEILING (AVG(Salary) - AVG(REPLACE(Salary, '0', ''))) FROM EMPLOYEES

---Bai_tap_3
SELECT 
ROUND(CAST(SUM(item_count * order_occurrences)/SUM(order_occurrences) AS DECIMAL), 1) AS mean
FROM items_per_order

---Bai_tap_4
SELECT 
ROUND(CAST(SUM(item_count * order_occurrences)/SUM(order_occurrences) AS DECIMAL), 1) AS mean
FROM items_per_order

---Bai_tap_5
SELECT candidate_id FROM candidates
WHERE skill IN ('Python','Tableau','PostgreSQL')
GROUP BY candidate_id
HAVING COUNT(skill)=3

---Bai_tap_6
SELECT user_id, 
MAX(DATE(post_date) - MIN(DATE(post_date) as days_between
FROM posts
WHERE COUNT(post_id)>=2
AND YEAR(post_date)=2021
GROUP BY user_id

---Bai_tap_7
SELECT user_id, 
(MAX(DATE(post_date)) - MIN(DATE(post_date))) as days_between
FROM posts
WHERE post_date BETWEEN '01-01-2021' AND'01-01-2022'
GROUP BY user_id
HAVING count(post_date)>=2

---Bai_tap_8
SELECT manufacturer,
ABS(SUM(cogs - total_sales)) AS total_loss,
COUNT(drug) AS drug_count
FROM pharmacy_sales
WHERE total_sales - cogs <= 0
GROUP BY manufacturer
ORDER BY total_loss DESC

---Bai_tap_9
SELECT * FROM Cinema
WHERE id%2= 1
AND description != 'boring'
ORDER BY movie

---Bai_tap_10


  ---Bai_tap_7

















