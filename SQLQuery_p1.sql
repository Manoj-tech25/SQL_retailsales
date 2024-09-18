-- SQL Retail Sales Analysis - P1
CREATE DATABASE [SQL - Retail Sales Analysis_utf];


-- Create TABLE
DROP TABLE IF EXISTS [SQL - Retail Sales Analysis_utf];
CREATE TABLE [SQL - Retail Sales Analysis_utf]
            (
                transaction_id INT PRIMARY KEY,	
                sale_date DATE,	 
                sale_time TIME,	
                customer_id	INT,
                gender	VARCHAR(15),
                age	INT,
                category VARCHAR(15),	
                quantity	INT,
                price_per_unit FLOAT,	
                cogs	FLOAT,
                total_sale FLOAT
            );

SELECT top 10 * FROM [SQL - Retail Sales Analysis_utf] 

SELECT 
    COUNT(*)  as NOofCol
FROM [SQL - Retail Sales Analysis_utf]

-- Data Cleaning
SELECT * FROM [SQL - Retail Sales Analysis_utf]
WHERE transactions_id IS NULL

SELECT * FROM [SQL - Retail Sales Analysis_utf]
WHERE sale_date IS NULL

SELECT * FROM [SQL - Retail Sales Analysis_utf]
WHERE sale_time IS NULL

SELECT * FROM [SQL - Retail Sales Analysis_utf]
WHERE 
    [transactions_id] IS NULL
    OR
    sale_date IS NULL
    OR 
    sale_time IS NULL
    OR
    gender IS NULL
    OR
    category IS NULL
    OR
    quantiy IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;
   /* Output : 5	2023-09-05	22:10:00.0000000	3	Male	30	Beauty	NULL	50	NULL	NULL
1004	2023-01-11	21:46:00.0000000	2	Male	37	Clothing	NULL	500	NULL	NULL
1988	2023-11-30	18:47:00.0000000	144	Female	63	Clothing	NULL	25	NULL	NULL*/
-- 
DELETE FROM [SQL - Retail Sales Analysis_utf]
WHERE 
    transactions_id IS NULL
    OR
    sale_date IS NULL
    OR 
    sale_time IS NULL
    OR
    gender IS NULL
    OR
    category IS NULL
    OR
    quantiy IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;

-- Data Exploration

-- How many sales we have?
SELECT COUNT(*) as total_sale FROM [SQL - Retail Sales Analysis_utf]

-- How many uniuque customers we have ?

SELECT COUNT(DISTINCT customer_id) as total_sale FROM [SQL - Retail Sales Analysis_utf]



SELECT DISTINCT category FROM [SQL - Retail Sales Analysis_utf]

-- Data Analysis & Business Key Problems & Answers

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)



-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
select * from [SQL - Retail Sales Analysis_utf] 
where sale_date = '2022-11-05'


-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than or equal 4 in the month of Nov-2022
SELECT 
  *
FROM [SQL - Retail Sales Analysis_utf]
WHERE 
     Category = 'Clothing'
  AND Quantiy >= 4
  AND Sale_Date >= '2022-11-01' 
  AND Sale_Date < '2022-12-01';


-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
select COUNT(*) as Total_orders from [SQL - Retail Sales Analysis_utf]
group by category


SELECT 
    category,
    SUM(total_sale) as net_sale,
    COUNT(*) as total_orders
FROM [SQL - Retail Sales Analysis_utf]
GROUP BY category


-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

select avg(age) as average_age from [SQL - Retail Sales Analysis_utf]
where category = 'Beauty'


-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
select *  from [SQL - Retail Sales Analysis_utf] 
where total_sale > 1000


-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
select Gender,Category , count(*) from [SQL - Retail Sales Analysis_utf] 
group by gender, category


-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
select top 2 YEAR(sale_date) as year,
        MONTH(sale_date) as month, avg(total_sale) as avgsale from [SQL - Retail Sales Analysis_utf]
group by YEAR(sale_date), MONTH(sale_date)
order by avgsale desc

SELECT 
    year,
    month,
    avg_sale
FROM 
(    
    SELECT 
        YEAR(sale_date) as year,
        MONTH(sale_date) as month,
        AVG(total_sale) as avg_sale,
        RANK() OVER(PARTITION BY YEAR(sale_date) ORDER BY AVG(total_sale) DESC) as rank
    FROM [SQL - Retail Sales Analysis_utf]
    GROUP BY YEAR(sale_date), MONTH(sale_date)
) as t1
WHERE rank = 1;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
select top 5 customer_id,sum(total_sale) as ts from [SQL - Retail Sales Analysis_utf]
group by customer_id
order by ts desc


-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT 
    category,    
    COUNT(DISTINCT customer_id) as cnt_unique_cs
FROM [SQL - Retail Sales Analysis_utf]
GROUP BY category


-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
WITH hourly_sale AS
(
    SELECT *,
        CASE
            WHEN DATEPART(HOUR, sale_time) < 12 THEN 'Morning'
            WHEN DATEPART(HOUR, sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
            ELSE 'Evening'
        END AS shift
    FROM [SQL - Retail Sales Analysis_utf]
)
SELECT 
    shift,
    COUNT(*) AS total_orders
FROM hourly_sale
GROUP BY shift;

-- End of project