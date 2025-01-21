# Just a block I can rerun to display the updated table as I make changes.
SELECT *
FROM walmart_sales_data;

# Checking for NULL values in the entire table.
SELECT *
FROM walmart_sales_data
WHERE NULL IN (`Invoice ID`, Branch, City, `Customer type`, Gender, `Product line`, `Unit price`, Quantity, `Tax 5%`, Total,
	Date, Time, Payment, cogs, `gross margin percentage`, `gross income`, Rating);
    
# Adding a time of day column for later analysis. Note that my choice of name for this column and following columns,
# while inconsistent with the given table, is what I was directed to use.
ALTER TABLE walmart_sales_data
ADD time_of_day TEXT AFTER Time;

# Filling the time_of_day column starting with mornings. Note that sorting the table by Time reveals locations open at
# 10AM and close at 9PM.
UPDATE walmart_sales_data
	SET time_of_day = 'Morning'
    WHERE Time LIKE "10%" OR Time LIKE "11%";
    
UPDATE walmart_sales_data
	SET time_of_day = 'Afternoon'
    WHERE Time LIKE "12%" OR Time LIKE "13%" OR Time LIKE "14%" OR Time LIKE "15%" OR Time LIKE "16%" OR Time LIKE "17%";
    
UPDATE walmart_sales_data
	SET time_of_day = 'Evening'
    WHERE Time LIKE "18%" OR Time LIKE "19%" OR Time LIKE "20%";
    
# Adding a day of the week column for later analysis.
ALTER TABLE walmart_sales_data
ADD day_name TEXT AFTER Date;

# Populating the day_name column with days of the week using the time series Date column as an arguement.
UPDATE walmart_sales_data
	SET day_name = DAYNAME(Date);
    
# Creating a new column which has the month name for later analysis.
ALTER TABLE walmart_sales_data
ADD month_name TEXT AFTER Date;

# Populating the month_name column with months of the year using the time series Date column as an arguement.
UPDATE walmart_sales_data
	SET month_name = MONTHNAME(Date);
    
    
# Now I'm moving from data wrangling and feature engineering to answering likely business questions. I'll report findings
# to a word document. The queries below should match the questions in the word document in order.


SELECT COUNT(DISTINCT City)
FROM walmart_sales_data;

SELECT DISTINCT Branch, City
FROM walmart_sales_data;

SELECT COUNT(DISTINCT `Product line`)
FROM walmart_sales_data;

SELECT Payment, COUNT(Payment)
FROM walmart_sales_data
GROUP BY Payment;

SELECT `Product line`, COUNT(`Product line`)
FROM walmart_sales_data
GROUP BY `Product line`;

SELECT month_name, SUM(TOTAL)
FROM walmart_sales_data
GROUP BY month_name;

SELECT month_name, SUM(cogs)
FROM walmart_sales_data
GROUP BY month_name;

SELECT `Product line`, SUM(Total)
FROM walmart_sales_data
GROUP BY `Product line`;

SELECT City, SUM(Total)
FROM walmart_sales_data
GROUP BY City;

SELECT `Product line`, SUM(`Tax 5%`)
FROM walmart_sales_data
GROUP BY `Product line`;

ALTER TABLE walmart_sales_data
ADD product_category TEXT AFTER `Product line`;

CREATE TABLE product_line_avg
SELECT walmart_sales_data.`Product line`, AVG(walmart_sales_data.Total)
FROM walmart_sales_data
GROUP BY `Product Line`;

SELECT *
FROM product_line_avg;

# I could have used product_line_avg.AVG(walmart_sales_data.Total) WHERE `Product line` = "Health and beauty" for the
# numbers, but I thought it would be easier to just copy and paste them. The numbers correspond to those values
# in the second table I made.
UPDATE walmart_sales_data
	SET product_category = 
    (CASE
		WHEN `Product line` = "Health and beauty" THEN IF(Total < 323.64301973684223, "Bad", "Good")
        WHEN `Product line` = "Electronic accessories" THEN IF(Total < 319.63253823529413, "Bad", "Good")
        WHEN `Product line` = "Home and lifestyle" THEN IF(Total < 336.63695625, "Bad", "Good")
        WHEN `Product line` = "Sports and travel" THEN IF(Total < 332.06521987951805, "Bad", "Good")
        WHEN `Product line` = "Food and beverages" THEN IF(Total < 322.6715172413793, "Bad", "Good")
        ELSE IF(Total < 305.089297752809, "Bad", "Good")
    END);

# This and the query beneath it can be ran consecutively and cross referenced
SELECT Branch, SUM(Quantity)
FROM walmart_sales_data
GROUP BY Branch;
    
SELECT AVG(subquery.sum_quantity) AS average_quantity_all_branches
FROM (
	SELECT Branch, SUM(Quantity) AS sum_quantity
	FROM walmart_sales_data
	GROUP BY Branch
) AS subquery;

SELECT `Product line`, COUNT(Gender)
FROM walmart_sales_data
WHERE Gender = 'Male'
GROUP BY `Product line`;

SELECT `Product line`, COUNT(Gender)
FROM walmart_sales_data
WHERE Gender = 'Female'
GROUP BY `Product line`;

SELECT `Product line`, AVG(Rating)
FROM walmart_sales_data
GROUP BY `Product line`;

SELECT day_name, time_of_day, COUNT(`Invoice ID`)
FROM walmart_sales_data
GROUP BY day_name, time_of_day;

SELECT `Customer type`, SUM(Total)
FROM walmart_sales_data
GROUP BY `Customer type`;

SELECT DISTINCT(`Customer type`)
FROM walmart_sales_data;

SELECT DISTINCT(Payment)
FROM walmart_sales_data;

SELECT `Customer type`, COUNT(`Customer type`)
FROM walmart_sales_data
GROUP BY `Customer type`;

SELECT `Customer type`, SUM(Quantity)
FROM walmart_sales_data
GROUP BY `Customer type`;

SELECT Gender, COUNT(`Invoice ID`)
FROM walmart_sales_data
GROUP BY Gender;

SELECT Branch, Gender, COUNT(Gender)
FROM walmart_sales_data
GROUP BY Branch, Gender;

SELECT Branch, time_of_day, AVG(Rating)
FROM walmart_sales_data
GROUP BY Branch, time_of_day;

SELECT Branch, day_name, AVG(Rating)
FROM walmart_sales_data
GROUP BY Branch, day_name;