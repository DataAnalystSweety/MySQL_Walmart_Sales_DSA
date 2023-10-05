-- Create database
CREATE DATABASE IF NOT EXISTS walmartSales;


-- Create table
CREATE TABLE IF NOT EXISTS sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    tax_pct FLOAT(6,4) NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT(11,9),
    gross_income DECIMAL(12, 4),
    rating FLOAT(2, 1)
);

SELECT
	*
FROM sales;


-- Add the time_of_day column
SELECT
	time,
	(CASE
		WHEN 'time' BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN 'time' BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END) AS time_of_day
FROM sales;

ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);

UPDATE sales
SET time_of_day = (
	CASE
		WHEN 'time' BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN 'time' BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END
);


-- Add day_name column
SELECT 
    date, DAYNAME(date) AS day_name
FROM
    sales;

ALTER TABLE sales ADD COLUMN day_name VARCHAR(10);

UPDATE sales 
SET 
    day_name = DAYNAME(date);


-- Add month_name column
SELECT 
    date, MONTHNAME(date) AS month_name
FROM
    sales;

ALTER TABLE sales ADD COLUMN month_name VARCHAR(10);

UPDATE sales 
SET 
    month_name = MONTHNAME(date);

-- Exploratory Data Analyse(EDA)

-- Generic Questions:

-- Q1. How many unique cities does the data have?

SELECT 
	DISTINCT city
FROM sales;

-- Q2. In which city the branches belong?

SELECT 
	DISTINCT city,
    branch
FROM sales;


-- Product Related Questions 

-- Q1. How many unique product lines does the data have?
SELECT
	DISTINCT product_line
FROM sales;


-- Q2. What are the top 5 most selling product line?
SELECT 
    product_line, SUM(quantity) AS quantity
FROM
    sales
GROUP BY product_line
ORDER BY quantity DESC
LIMIT 5;


-- Q3. What is the most common payment method?
SELECT 
    payment, COUNT(payment) AS No_of_Times
FROM
    sales
GROUP BY payment
ORDER BY No_of_Times DESC;

-- Q4. What is the total revenue by month
SELECT 
    month_name AS month, SUM(total) AS total_revenue
FROM
    sales
GROUP BY month_name
ORDER BY total_revenue;


-- Q5. What month had the highest COGS?
SELECT
	month_name AS month,
	SUM(cogs) AS cogs
FROM sales
GROUP BY month_name 
ORDER BY cogs;


-- Q6. What product line had the highest revenue?
SELECT 
    product_line, SUM(total) AS total_revenue
FROM
    sales
GROUP BY product_line
ORDER BY total_revenue DESC;

-- Q7. Which city had largest revenue?
SELECT 
    branch, city, SUM(total) AS total_revenue
FROM
    sales
GROUP BY city , branch
ORDER BY total_revenue;


-- Q8. What product line had the highest VAT?
SELECT 
    product_line, AVG(tax_pct) AS VAT
FROM
    sales
GROUP BY product_line
ORDER BY VAT DESC;


-- Q9. Fetch each product line and add a column to those product line showing 
--     "Good" if its greater than average sales else "Bad".

SELECT 
	AVG(total) AS avg_sales
FROM sales;

SELECT
	product_line, 
	CASE
		WHEN AVG(total) > 322 THEN "Good"
        ELSE "Bad"
    END AS remark
FROM sales
GROUP BY product_line;


-- Q10. What is the most common product line by gender
SELECT 
    product_line, gender, COUNT(gender) AS total_cnt
FROM
    sales
GROUP BY gender , product_line
ORDER BY total_cnt DESC;


-- Q11. What is the average rating of each product line
SELECT 
    product_line, ROUND(AVG(rating), 2) AS avg_rating
FROM
    sales
GROUP BY product_line
ORDER BY avg_rating DESC;



-- Customers Related Questions

-- Q1. How many unique customer types does the data have?
SELECT
	DISTINCT customer_type
FROM sales;


-- Q2. How many unique payment methods does the data have?
SELECT
	DISTINCT payment
FROM sales;


-- Q3. Which customer type buys the most?
SELECT 
    customer_type, COUNT(customer_type) AS cus_count
FROM
    sales
GROUP BY customer_type
ORDER BY cus_count DESC;


-- Q4. Which gender gave the highest sales?
SELECT
	gender,
	COUNT(*) as gender_cnt
FROM sales
GROUP BY gender
ORDER BY gender_cnt DESC;


-- Q5. What is the customer distribution by gender per branch?
SELECT 
    branch, gender, COUNT(gender) AS gender_cnt
FROM
    sales
GROUP BY branch , gender
ORDER BY branch;


-- Q6. Which time of the day do customers give most ratings?
SELECT 
    time_of_day,
    COUNT(time_of_day) AS No_of_Rating,
    ROUND(AVG(rating), 2) AS Avg_rating
FROM
    sales
GROUP BY time_of_day
ORDER BY No_of_Rating DESC;


-- Q7. Which branch gets best average rating?
SELECT 
    branch, ROUND(AVG(rating), 2) AS Avg_rating
FROM
    sales
GROUP BY branch
ORDER BY Avg_rating DESC;
-- Branch A and C are doing well in ratings, branch B needs to do a 
-- little more to get better ratings.


-- Q8. Which day of the week has the best avg ratings?
SELECT
	day_name,
	ROUND(AVG(rating), 2) AS Avg_rating
FROM sales
GROUP BY day_name 
ORDER BY Avg_rating DESC;
-- Mon, Tue and Friday are the top best days for good ratings



-- Sales Related Questions

-- Q1. Number of sales made in each time of the day 
SELECT 
    time_of_day, COUNT(*) AS total_sales
FROM
    sales
GROUP BY time_of_day
ORDER BY total_sales DESC;
-- Evenings experience most sales.
 
 
-- Q2. Which of the customer types brings the most revenue?
SELECT 
    customer_type, ROUND(SUM(total), 2) AS total_revenue
FROM
    sales
GROUP BY customer_type
ORDER BY total_revenue;


-- Q3. Which city has the largest tax/VAT percent?
SELECT
	city,
    ROUND(AVG(tax_pct), 2) AS Avg_tax_pct
FROM sales
GROUP BY city 
ORDER BY Avg_tax_pct DESC;

-- Q4. Which customer type pays the most in VAT?
SELECT
	customer_type,
	ROUND(AVG(tax_pct), 2) AS total_tax
FROM sales
GROUP BY customer_type
ORDER BY total_tax;

-- --------------------------------------------------------------------
-- --------------------------------------------------------------------