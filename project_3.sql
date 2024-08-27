---1, Doanh thu theo từng ProductLine, Year  và DealSize
SELECT productLine, year_id, dealsize,
SUM(sales) AS revenue
FROM public.sales_dataset_rfm_prj_clean
GROUP BY productLine, year_id, dealsize;

---2, Tháng có bán tốt nhất mỗi năm
WITH cte AS (
    SELECT 
        year_id, 
        month_id,
        SUM(sales) AS revenue
    FROM public.sales_dataset_rfm_prj_clean
    GROUP BY year_id, month_id
)

SELECT 
    year_id, month_id, revenue
FROM (
    SELECT year_id, month_id, revenue,
        ROW_NUMBER() OVER (PARTITION BY year_id ORDER BY revenue DESC) AS rank
    FROM monthly_revenue
) ranked_months
WHERE rank = 1
ORDER BY year_id

---3, Product line được bán nhiều ở tháng 11
SELECT productline,
SUM(sales) AS revenue
FROM public.sales_dataset_rfm_prj_clean
WHERE month_id =11
GROUP BY productline 
ORDER BY SUM(sales) DESC

---4, Sản phẩm có doanh thu tốt nhất ở UK mỗi năm
SELECT * 
FROM (
    SELECT year_id, productline,
        SUM(sales) AS revenue,
        RANK() OVER (PARTITION BY year_id ORDER BY SUM(sales) DESC) AS rank
    FROM public.sales_dataset_rfm_prj_clean
    WHERE 
        country = 'UK'
    GROUP BY productline, year_id
) AS b
WHERE rank = 1
ORDER BY year_id

---5, Ai là khách hàng tốt nhất, phân tích dựa vào RFM
WITH cte AS (
SELECT contactfullname,
current_date-Max(orderdate) AS R,
COUNT(DISTINCT ordernumber) AS F,
SUM(sales) AS M
FROM public.sales_dataset_rfm_prj_clean AS a
GROUP BY contactfullname),

rfm_score AS(
SELECT contactfullname,
ntile(5) OVER(ORDER BY R DESC) AS R_score,
ntile(5) OVER(ORDER BY F) AS F_score,
ntile(5) OVER(ORDER BY M) AS M_score
FROM cte),

rfm_final AS (
SELECT contactfullname,
CAST(r_score AS varchar)||CAST(F_score AS varchar)||CAST(M_score AS varchar) AS rfm_score
FROM rfm_score)

SELECT a.contactfullname, b.sefment FROM 
rfm_final AS a 
JOIN segment_score AS b ON a.rfm_score = b.scores 
WHERE b.sefment= 'Champions'












