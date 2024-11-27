-- DATABASE CREATION

CREATE DATABASE retail_db;
USE retail_db;
DROP DATABASE retail_db;

-- TABLE CREATION

CREATE TABLE retail_sales(
      transactions_id INT PRIMARY KEY,
      sale_date DATE,
      sale_time TIME,
      customer_id INT,
      gender VARCHAR(10),
      age INT,
      category VARCHAR(35),
      quantity INT,
      price_per_unit FLOAT,
      cogs FLOAT,
      total_sale FLOAT
      );
INSERT INTO retail_sales(transactions_id, sale_date, sale_time, customer_id, gender, age, category, quantity, price_per_unit, cogs, total_sale) 
VALUES 
 (101, '2022-11-05', 8, 1, 'Female', 68, 'clothing', 952, 908.85, 384.13, 8529.94),
 (102, '2023-10-04', 20, 2, 'Female', 44, 'electronics', 535, 592.29, 622.78, 4814.84),
 (103, '2024-09-02', 17, 3, 'Male', 72, 'clothing', 302, 825.17, 990.92, 9577.79),
 (104, '2021-08-03', 48, 4, 'Male', 39, 'electronics', 14, 199.76, 624.44, 3130.61),
 (105, '2020-07-01', 11, 5, 'Agender', 79, 'clothing', 625, 97.49, 336.09, 4617.73);
 -- DATA EXPLORATION & CLEANING 
 
SELECT COUNT(*) FROM retail_sales;
SELECT COUNT(DISTINCT customer_id) FROM retail_sales;
SELECT DISTINCT category from retail_sales;
SELECT * FROM retail_sales;

SELECT * FROM retail_sales 
WHERE 
     sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR gender IS NULL OR age IS NULL OR category IS NULL OR quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;
SET SQL_SAFE_UPDATES=0;
DELETE FROM retail_sales
WHERE
     sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR gender IS NULL OR age IS NULL OR category IS NULL OR quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;
-- DATA ANALYSIS AND FINDINGS

/* 1.Write a query to retrieve all the columns for sales made on '2022-11-05'*/
 
SELECT * FROM retail_sales WHERE sale_date='2020-07-01';  

/* 2.Write a SQL query to retrieve all transactions where the category is 'clothing' and 
the quantity sold is more than 4 in the month of nov-2022*/

SELECT * FROM retail_sales
WHERE
   category='clothing'
   AND 
   sale_date ='2022-11-05'
   AND
   quantity >= 4
   

/* 3.Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category*/

SELECT ROUND(AVG(age),2) as avg_age FROM retail_sales WHERE category='Beauty';

/* 4.Write a SQL query to calculate the total sales for each category*/

SELECT 
     category,
     SUM(total_sale) AS total_sales,
     COUNT(*) AS total_orders
FROM retail_sales
GROUP BY 1;

/* 5.Write a SQL query to find all transactions where the total_sale is greater than 1000*/

SELECT * FROM retail_sales
WHERE total_sale > 1000;

/* 6.Write a SQL query to calculate the total no of transactions made by each gender in each category*/

SELECT category,gender,COUNT(*) AS total_trans FROM retail_sales
GROUP BY category,gender 
ORDER BY 1;

/* 7.Write a SQL query to calculate the average sale for each month.Find out best selling month in each year*/

SELECT year,month,avg_sale 
FROM 
(
SELECT EXTRACT(YEAR FROM sale_date) AS year,EXTRACT(MONTH FROM sale_date) AS month,
     AVG(total_sale) AS avg_sale,
     RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale)
DESC) AS rank
FROM retail_sales GROUP BY 1,2) AS t1 WHERE rank=1;

/* 8.Write a SQL query to find the top 5 customers based on the highest total sales*/

SELECT customer_id,SUM(total_sale) as total_sales
FROM retail_sales GROUP BY 1
ORDER BY 2 DESC LIMIT 5;

/* 9.Write a SQL query to find the no of unique customers who purchased items from each category*/

SELECT category,COUNT(DISTINCT customer_id) AS cnt_unique_cs
FROM retail_sales GROUP BY category;

/* 10.Write a SQL query to create each shift and no of orders(ex:morning <12,afternoon btwn 12 & 17,evening>17)*/

WITH hourly_sale
AS
(
SELECT *,
    CASE
      WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
      WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
      ELSE 'Evening'
	END AS shift
FROM retail_sales
)
SELECT
     shift,
     COUNT(*) AS total_orders
	FROM hourly_sale
    GROUP BY shift;



   