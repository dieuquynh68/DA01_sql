--- Bai_tap_1
SELECT NAME from CITY
WHERE COUNTRYCODE = 'USA'
AND POPULATION > 120000

--- Bai_tap_2
SELECT * from CITY
WHERE COUNTRYCODE = 'JPN'

--- Bai_tap_3
SELECT CITY, STATE from STATION

--- Bai_tap_4
SELECT DISTINCT CITY from STATION
WHERE CITY LIKE 'a%' OR CITY LIKE 'e%' OR CITY LIKE 'i%' OR CITY LIKE 'o%' OR CITY LIKE 'u%'
ORDER BY CITY

--- Bai_tap_5
SELECT DISTINCT CITY from STATION
WHERE CITY LIKE '%a' OR CITY LIKE '%e' OR CITY LIKE '%i' OR CITY LIKE '%o' OR CITY LIKE '%u'
ORDER BY CITY

--- Bai_tap_6
SELECT DISTINCT CITY from STATION
WHERE NOT (CITY LIKE 'a%' OR CITY LIKE 'e%' OR CITY LIKE 'i%' OR CITY LIKE 'o%' OR CITY LIKE 'u%')
ORDER BY CITY

--- Bai_tap_7
SELECT name from Employee
ORDER BY name ASC

--- Bai_tap_8
SELECT name from Employee
WHERE salary > 2000 AND months < 10
ORDER BY employee_id ASC

--- Bai_tap_9
SELECT DISTINCT product_id from Products
WHERE low_fats = 'Y' AND recyclable = 'Y'

--- Bai_tap_10
SELECT name from Customer
WHERE referee_id != 2 or referee_id is null

--- Bai_tap_11
SELECT name, population, area FROM World
WHERE area >=3000000 OR population >=25000000
ORDER BY name

--- Bai_tap_12
SELECT DISTINCT author_id as id from Views
WHERE author_id = viewer_id
ORDER BY id ASC

--- Bai_tap_13
SELECT part, assembly_step FROM parts_assembly
WHERE finish_date IS NULL

--- Bai_tap_14
SELECT * FROM lyft_drivers
WHERE yearly_salary <= 30000 or yearly_salary >= 70000

--- Bai_tap_15
SELECT * from uber_advertising 
WHERE year = 2019 AND money_spent > 100000



























