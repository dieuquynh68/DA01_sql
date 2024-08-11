--- Question_1	
SELECT DISTINCT replacement_cost FROM film
ORDER BY replacement_cost ASC

---Question_2
SELECT 
SUM(CASE WHEN replacement_cost BETWEEN 9.99 AND 19.99 THEN 1 ELSE 0 END) AS low_replacement_cost,
SUM(CASE WHEN replacement_cost BETWEEN 20.00 AND 24.99 THEN 1 ELSE 0 END) AS medium_replacement_cost,
SUM(CASE WHEN replacement_cost BETWEEN 25.00 AND 29.99 THEN 1 ELSE 0 END) AS high_replacement_cost
FROM film

---Question_3
SELECT a.title, a.length, c.name AS category_name
FROM film AS a
JOIN film_category AS b ON a.film_id = b.film_id
JOIN category AS c ON b.category_id = c.category_id
WHERE c.name IN ('Drama','Sports')
ORDER BY a.length DESC

---Question_4
SELECT c.name AS category_name,
COUNT(title)
FROM film AS a
JOIN film_category AS b ON a.film_id = b.film_id
JOIN category AS c ON b.category_id = c.category_id
GROUP BY c.name
ORDER BY count DESC

---Question_5
SELECT a.first_name, a.last_name,
COUNT(film_id) AS film_quantity
FROM actor AS a
JOIN film_actor AS b
ON a.actor_id = b.actor_id
GROUP BY a.first_name, a.last_name
ORDER BY film_quantity DESC

---Question_6
SELECT COUNT(*) AS unassociated_addresses
FROM address AS a
LEFT JOIN customer AS b
ON a.address_id = b.address_id
WHERE b.customer_id IS NULL

---Question_7 
SELECT a.city,
SUM(d.amount) AS revenue
FROM city AS a
JOIN address AS b ON a.city_id = b.city_id
JOIN customer AS c ON b.address_id = c.address_id
JOIN payment AS d ON c.customer_id = d.customer_id
GROUP BY a.city
ORDER BY revenue DESC

---Question_8
SELECT CONCAT(e.country,', ', a.city) AS country_city,
SUM(d.amount) AS revenue
FROM city AS a
JOIN address AS b ON a.city_id = b.city_id
JOIN customer AS c ON b.address_id = c.address_id
JOIN payment AS d ON c.customer_id = d.customer_id
JOIN country AS e ON a.country_id = e.country_id
GROUP BY e.country, a.city
ORDER BY revenue ASC



















