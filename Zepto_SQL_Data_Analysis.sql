-- Droping the table if zepto table is exists--
drop table if exists zepto;

--Creating a Table called as zepto--
create table zepto (
sku_id SERIAL PRIMARY KEY,
category VARCHAR(120),
name VARCHAR(150) NOT NULL,
mrp NUMERIC(8,2),
discountPercent NUMERIC(5,2),
availableQuantity INTEGER,
discountedSellingPrice NUMERIC(8,2),
weightInGms INTEGER,
outOfStock BOOLEAN,	 
quantity INTEGER
);

--data exploration

--sample data

Select * from zepto;

SELECT * FROM zepto
LIMIT 10;

--count of rows
select count(*) from zepto;

-- Checking the null values
SELECT * FROM zepto
WHERE name IS NULL
OR
category IS NULL
OR
mrp IS NULL
OR
discountPercent IS NULL
OR
discountedSellingPrice IS NULL
OR
weightInGms IS NULL
OR
availableQuantity IS NULL
OR
outOfStock IS NULL
OR
quantity IS NULL;

--different product categories
SELECT DISTINCT category
FROM zepto
ORDER BY category;

--products in stock vs out of stock
SELECT outOfStock, COUNT(sku_id)
FROM zepto
GROUP BY outOfStock;

--product names present multiple times
SELECT name, COUNT(sku_id) AS "Number of SKUs"
FROM zepto
GROUP BY name
HAVING count(sku_id) > 1
ORDER BY count(sku_id) DESC;

--***Data Cleaning***---

--products with price = 0
SELECT * FROM zepto
WHERE mrp = 0 OR discountedSellingPrice = 0;

DELETE FROM zepto
WHERE mrp = 0;

--convert paise to rupees
UPDATE zepto
SET mrp = mrp / 100.0,
discountedSellingPrice = discountedSellingPrice / 100.0;

SELECT mrp, discountedSellingPrice FROM zepto;

---***Data analysis***---

-- Finding the top 10 best-value products based on the discount percentage.
SELECT DISTINCT name, mrp, discountPercent
FROM zepto
ORDER BY discountPercent DESC
LIMIT 10;

-- Finding what are the Products with High MRP but Out of Stock



SELECT DISTINCT name,mrp
FROM zepto
WHERE outOfStock = TRUE and mrp > 300
ORDER BY mrp DESC;

--Use Case Of Window functions Over()---

--secnerio -1

SELECT name, mrp, discountPercent
FROM (SELECT name,mrp,discountPercent,
        ROW_NUMBER() OVER (ORDER BY discountPercent DESC) AS RN
		FROM zepto) 
		ranked
WHERE RN <= 10

--secnerio -2

SELECT name, mrp, discountPercent
FROM (
    SELECT 
        name,
        mrp,
        discountPercent,
        RANK() OVER (ORDER BY discountPercent DESC) AS Rnk
    FROM zepto
) ranked
WHERE Rnk <= 10;

-- Calculate Estimated Revenue for each by category
SELECT category,
SUM(discountedSellingPrice * availableQuantity) AS total_revenue
FROM zepto
GROUP BY category
ORDER BY total_revenue;

-- Finding all products where MRP is greater than ₹500 and discount is less than 10%.
SELECT DISTINCT name, mrp, discountPercent
FROM zepto
WHERE mrp > 500 AND discountPercent < 10
ORDER BY mrp DESC, discountPercent DESC;

-- Finding the top 5 categories offering the highest average discount percentage.
SELECT category,
ROUND(AVG(discountPercent),2) AS avg_discount
FROM zepto
GROUP BY category
ORDER BY avg_discount DESC
LIMIT 5;

-- Finding the price per gram for products above 100g and sort by best value.
SELECT DISTINCT name, weightInGms, discountedSellingPrice,
ROUND(discountedSellingPrice/weightInGms,2) AS price_per_gram
FROM zepto
WHERE weightInGms >= 100
ORDER BY price_per_gram;

-- Group the products into categories like Low, Medium, Bulk.
SELECT DISTINCT name, weightInGms,
CASE WHEN weightInGms < 1000 THEN 'Low'
	WHEN weightInGms < 5000 THEN 'Medium'
	ELSE 'Bulk'
	END AS weight_category
FROM zepto;

-- Find what is the Total Inventory Weight Per Category 
SELECT category,
SUM(weightInGms * availableQuantity) AS total_weight
FROM zepto
GROUP BY category
ORDER BY total_weight;

---To find the top N Products per Category by Discount

SELECT category, name, mrp, discountPercent, discountedSellingPrice
FROM (
    SELECT 
        category,
        name,
        mrp,
        discountPercent,
        discountedSellingPrice,
        ROW_NUMBER() OVER (
            PARTITION BY category 
            ORDER BY discountPercent DESC
        ) AS rn
    FROM zepto
) ranked
WHERE rn <= 5;

--- Ranking Products by Discount Within Category

SELECT 
    category,
    name,
    discountPercent,
    RANK() OVER (
        PARTITION BY category
         ORDER BY discountPercent DESC) as disc_rank
FROM zepto;
------limit 
SELECT 
    category,
    name,
    discountPercent,
    RANK() OVER (
        PARTITION BY category 
        ORDER BY discountPercent DESC
    ) AS disc_rank
FROM zepto limit 10;

----Finding the Highest Discounted Product in Each Category

SELECT category, name, discountPercent
FROM (
    SELECT 
        category,
        name,
        discountPercent,
        MAX(discountPercent) OVER (PARTITION BY category) AS max_discount
    FROM zepto
) sub
WHERE discountPercent = max_discount;

--finding running Total of Available Quantity per Category
--it track cumulative stock availability by category

SELECT 
    category,
    name,
    availableQuantity,
    SUM(availableQuantity) OVER (
        PARTITION BY category 
        ORDER BY name
    ) AS running_total
FROM zepto;

---Percentage Contribution of Each Product’s Discount to Category

SELECT 
    category,
    name,
    discountPercent,
    ROUND(
        discountPercent * 100.0 / SUM(discountPercent) OVER (PARTITION BY category), 2
    ) AS discount_share
FROM zepto;

---****Top 5 products per category****---

SELECT category, name, discountPercent
FROM (
    SELECT category, name, discountPercent,
           ROW_NUMBER() OVER (PARTITION BY category ORDER BY discountPercent DESC) AS rn
    FROM zepto
) ranked
WHERE rn <= 5;

----*****Top 10 best-value products*****----

SELECT name, mrp, discountPercent
FROM (
    SELECT name, mrp, discountPercent,
           ROW_NUMBER() OVER (ORDER BY discountPercent DESC) AS rn
    FROM zepto
) ranked
WHERE rn <= 10;