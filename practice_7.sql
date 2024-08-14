---Bai_tap_1
WITH yearly_spend_cte AS (
SELECT 
EXTRACT(YEAR FROM transaction_date) AS yr,
product_id,
spend AS curr_year_spend,
LAG(spend) OVER (
PARTITION BY product_id 
ORDER BY 
product_id, 
EXTRACT(YEAR FROM transaction_date)) AS prev_year_spend 
FROM user_transactions)

SELECT 
yr,
product_id, 
curr_year_spend, 
prev_year_spend, 
ROUND(100 * 
(curr_year_spend - prev_year_spend)
/ prev_year_spend, 2) AS yoy_rate 
FROM yearly_spend_cte

---Bai_tap_2
WITH cte AS (
SELECT 
card_name,
issued_amount,
issue_month,
issue_year,
FIRST_VALUE(issued_amount) OVER (
PARTITION BY card_name 
ORDER BY issue_year, issue_month) AS launch_amount
FROM monthly_cards_issued
)
SELECT 
card_name, 
launch_amount AS issued_amount
FROM cte
GROUP BY card_name, launch_amount
ORDER BY issued_amount DESC

---Bai_tap_3
WITH ranked_transactions AS (
SELECT 
user_id, 
spend, 
transaction_date,
ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY transaction_date) AS rn
FROM transactions
)
SELECT 
user_id, 
spend, 
transaction_date
FROM ranked_transactions
WHERE rn = 3

---Bai_tap_4
WITH cte AS
(SELECT transaction_date, product_id, user_id,
RANK() OVER (PARTITION BY user_id ORDER BY transaction_date DESC) AS rank
FROM user_transactions)
SELECT transaction_date, user_id,
COUNT(product_id) purchase_count
FROM cte 
WHERE rank=1
GROUP BY transaction_date, user_id
ORDER BY transaction_date

---Bai_tap_5
SELECT t1.user_id, 
    t1.tweet_date, 
ROUND(AVG(t2.tweet_count), 2) AS rolling_avg_3d
FROM tweets t1
JOIN tweets t2
ON t1.user_id = t2.user_id 
AND t2.tweet_date BETWEEN t1.tweet_date - INTERVAL '2 DAY' AND t1.tweet_date
GROUP BY t1.user_id, t1.tweet_date
ORDER BY t1.user_id, t1.tweet_date

---Bai_tap_6
 WITH cte1 as
 (SELECT *, lag(transaction_timestamp) OVER(PARTITION BY 
 merchant_id, credit_card_id, amount order by transaction_timestamp) 
 AS prev_transaction_time
 FROM transactions)

SELECT count(transaction_id) as payment_count
FROM cte1
WHERE EXTRACT(epoch from transaction_timestamp - 
prev_transaction_time)/60 <=10;   

---Bai_tap_7
SELECT category, product, total_spend 
FROM (
  SELECT 
    category, 
    product, 
    SUM(spend) AS total_spend,
    RANK() OVER (
      PARTITION BY category 
      ORDER BY SUM(spend) DESC) AS rank 
  FROM product_spend
  WHERE EXTRACT(YEAR FROM transaction_date) = 2022
  GROUP BY category, product
) AS ranked_spending
WHERE rank <= 2 
ORDER BY category, rank

---Bai_tap_8
WITH cte_a AS (
SELECT a.artist_id, a.artist_name, 
DENSE_RANK () OVER (ORDER BY  COUNT(s.song_id) DESC) Top_rank FROM artists a
INNER JOIN songs s ON  a.artist_id = s.artist_id
INNER JOIN global_song_rank g ON s.song_id = g.song_id
WHERE rank<=10
GROUP BY a.artist_id,a.artist_name
)
SELECT artist_name, Top_rank FROM cte_a 
WHERE Top_rank <=5





















































