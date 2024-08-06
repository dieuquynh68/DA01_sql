--- Bai_tap_1
SELECT Name FROM STUDENTS
WHERE Marks > 75
ORDER BY RIGHT(Name,3), ID ASC

--- Bai_tap_2
SELECT user_id,
CONCAT(UPPER(LEFT(name,1)),LOWER(RIGHT(name,LENGTH(name)-1))) AS name
FROM Users
ORDER BY user_id

--- Bai_tap_3
SELECT manufacturer,
'$'||ROUND(SUM(total_sales)/1000000,0)||' million'
FROM pharmacy_sales
GROUP BY manufacturer
ORDER BY SUM(total_sales) DESC, manufacturer ASC

--- Bai_tap_4
SELECT  
EXTRACT(month FROM submit_date) AS mth,
product_id,
ROUND(AVG(stars),2) AS avg_stars
FROM reviews
GROUP BY EXTRACT(month FROM submit_date), product_id
ORDER BY mth, product_id

--- Bai_tap_5
SELECT sender_id,
COUNT(content) AS message_count
FROM messages
WHERE EXTRACT(month FROM sent_date) = 08
AND EXTRACT (year FROM sent_date) = 2022
GROUP BY sender_id
ORDER BY COUNT(content) DESC
LIMIT 2

--- Bai_tap_6
SELECT tweet_id
FROM Tweets
WHERE LENGTH(content)>15

--- Bai_tap_7
SELECT activity_date as day, COUNT(DISTINCT user_id) as active_users
FROM Activity
WHERE activity_date BETWEEN '2019-06-27' AND '2019-07-28'
GROUP BY activity_date

--- Bai_tap_8
SELECT 
COUNT(id) as number_employee
FROM employees
WHERE EXTRACT (month FROM joining_date) BETWEEN 1 and 7
AND EXTRACT (year FROM joining_date) = 2022

--- Bai_tap_9
SELECT 
POSITION('a' IN first_name) AS position
FROM employee 
WHERE first_name = 'Amitah'

--- Bai_tap_10
SELECT 
SUBSTRING(title, length(winery)+2,4)
FROM winemag_p2
WHERE country='Macedonia'












