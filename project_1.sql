--1,
ALTER TABLE SALES_DATASET_RFM_PRJ
ALTER COLUMN ordernumber TYPE integer USING ordernumber::integer,
ALTER COLUMN quantityordered TYPE integer USING quantityordered::integer,
ALTER COLUMN priceeach TYPE DECIMAL(10, 2) USING priceeach::DECIMAL,
ALTER COLUMN orderlinenumber TYPE INTEGER USING orderlinenumber::INTEGER,
ALTER COLUMN sales TYPE DECIMAL(10,2) USING sales::DECIMAL,
ALTER COLUMN status TYPE TEXT,
ALTER COLUMN productline TYPE TEXT,
ALTER COLUMN msrp TYPE INTEGER USING msrp::INTEGER,
ALTER COLUMN customername TYPE TEXT,
ALTER COLUMN addressline1 TYPE TEXT,
ALTER COLUMN addressline2 TYPE TEXT,
ALTER COLUMN city TYPE TEXT,
ALTER COLUMN state TYPE TEXT,
ALTER COLUMN country TYPE TEXT,
ALTER COLUMN territory TYPE TEXT,
ALTER COLUMN contactfullname TYPE TEXT,	
ALTER COLUMN dealsize TYPE TEXT	


--2,
SELECT *
FROM SALES_DATASET_RFM_PRJ
WHERE 
    ordernumber IS NULL 
    OR quantityordered IS NULL 
    OR priceeach IS NULL
    OR orderlinenumber IS NULL 
    OR sales IS NULL 
    OR orderdate IS NULL


--3,
ALTER TABLE SALES_DATASET_RFM_PRJ
ADD contactlastname VARCHAR(255),
ADD contactfirstname VARCHAR(255)
	
UPDATE SALES_DATASET_RFM_PRJ
SET contactfirstname = UPPER(RIGHT(contactfullname, LENGTH(contactfullname) - POSITION('-' IN contactfullname))),
	contactlastname = UPPER(LEFT(contactfullname, POSITION('-' IN contactfullname)-1))

--4,
ALTER TABLE SALES_DATASET_RFM_PRJ
ADD QTR_ID INT,
ADD MONTH_ID INT,
ADD YEAR_ID INT;

UPDATE SALES_DATASET_RFM_PRJ
SET 
    MONTH_ID = EXTRACT(MONTH FROM orderdate),
    YEAR_ID = EXTRACT(YEAR FROM orderdate),
    QTR_ID = CASE
                WHEN EXTRACT(MONTH FROM orderdate) IN (1, 2, 3) THEN 1
                WHEN EXTRACT(MONTH FROM orderdate) IN (4, 5, 6) THEN 2
                WHEN EXTRACT(MONTH FROM orderdate) IN (7, 8, 9) THEN 3
                WHEN EXTRACT(MONTH FROM orderdate) IN (10, 11, 12) THEN 4
             END;

--5, 
-- C1: IQR

WITH min_max_value AS
(SELECT Q1-1.5*IQR AS min_value,
Q3+1.5*IQR AS max_value
FROM (
SELECT 
PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY quantityordered) AS Q1,
PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY quantityordered) AS Q3,
PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY quantityordered)- PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY quantityordered) AS IQR
FROM SALES_DATASET_RFM_PRJ) AS a)

SELECT * FROM SALES_DATASET_RFM_PRJ
WHERE quantityordered< (select min_value from min_max_value)
OR quantityordered> (select max_value from min_max_value)


-- C2: Z-score
SELECT AVG(quantityordered),
stddev(quantityordered)
FROM SALES_DATASET_RFM_PRJ

WITH cte AS
(
SELECT ordernumber, priceeach, quantityordered,
(SELECT avg(quantityordered)
	FROM SALES_DATASET_RFM_PRJ) AS avg,
(SELECT stddev(quantityordered)
	FROM SALES_DATASET_RFM_PRJ) AS stddev
FROM SALES_DATASET_RFM_PRJ),
outlier AS()
SELECT ordernumber, priceeach, (quantityordered - avg)/stddev AS z_score
FROM cte
WHERE abs (quantityordered-avg)/stddev >2)


--6,
CREATE TABLE SALES_DATASET_RFM_PRJ_CLEAN 
INSERT INTO SALES_DATASET_RFM_PRJ_CLEAN 
SELECT * FROM SALES_DATASET_RFM_PRJ
WHERE ordernumber NOT IN (SELECT ordernumber FROM outliers)























