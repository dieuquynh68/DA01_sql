Bai_tap_1
SELECT
SUM(CASE
     WHEN device_type = 'laptop' THEN 1
     ELSE 0
     END) AS laptop_reviews,
    
SUM(CASE 
    WHEN device_type IN ('tablet', 'phone')  THEN 1
     ELSE 0
     END) AS mobile_views
FROM viewership

Bai_tap_2
SELECT x,y,z,
CASE
  WHEN x+y>z AND y+z>x AND x+z>y THEN 'Yes'
  ELSE 'No'
  END AS triangle
FROM Triangle

Bai_tap_3
SELECT 
ROUND(100 * 
CAST((SUM(CASE
       WHEN call_category IS NULL OR call_category = 'n/a' THEN 1
       ELSE 0
     END) 
    ) AS DECIMAL) / (SELECT COUNT(*) FROM callers), 1) AS uncategorised_call_pct
FROM callers

Bai_tap_4
SELECT name from Customer
WHERE referee_id != 2 or referee_id is null

Bai_tap_5
SELECT survived,
SUM(CASE
    WHEN pclass= '1' THEN 1
    ELSE 0
    END) first_class,

SUM(CASE
    WHEN pclass= '2' THEN 1
    ELSE 0
    END) second_class,
    
 SUM(CASE
    WHEN pclass= '3' THEN 1
    ELSE 0
    END) third_class  
FROM titanic
GROUP BY survived
































