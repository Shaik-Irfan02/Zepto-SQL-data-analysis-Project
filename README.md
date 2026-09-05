## Zepto-SQL-data-analysis-Project

# 📌 Project Description
This project explores a retail dataset (`zepto`) containing product details such as category, name, MRP, discount percentage, available quantity, selling price, weight, and stock status.  
The focus is on **SQL data cleaning, exploration, and analysis** with practical use cases of **Window Functions** (`ROW_NUMBER`, `RANK`, `SUM`, `MAX`) and **PARTITION BY** for category‑wise insights.

---

## 🛠️ Table Schema
```sql
CREATE TABLE zepto (
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

#🔍 Key Highlights
Data Cleaning: Removed invalid rows, converted paise to rupees.

Exploration: Row counts, null checks, distinct categories, stock status.

Window Functions:

Top N products overall and per category by discount.

Ranking products with ties (RANK, DENSE_RANK).

Highest discounted product per category (MAX OVER).

Running totals of available quantity (SUM OVER).

Percentage contribution of each product’s discount (PARTITION BY).

Category Insights:

Average discount per category.

Inventory weight distribution.

Price per gram for value comparison.

#📈 Example Query
Top 5 products per category by discount:

sql
SELECT category, name, discountPercent
FROM (
    SELECT category, name, discountPercent,
           ROW_NUMBER() OVER (
               PARTITION BY category ORDER BY discountPercent DESC
           ) AS rn
    FROM zepto
) ranked
WHERE rn <= 5;

#🚀 Insights
Window functions enable ranking, cumulative totals, and comparisons without collapsing rows.

PARTITION BY resets calculations per category, making category‑wise analysis possible.

The dataset highlights best‑value products, stock trends, and discount contributions across categories.

#👨‍💻 Author
Developed by Irfan Shaik
Focus: SQL Analytics, Window Functions, and Retail Data Insights


This version is short, professional, and GitHub‑ready. It gives a clear **description**, schema, highlights, one example query, and insights — all in one summary.  

Would you like me to also add a **project workflow diagram** (data cleaning → exploration → analysis → insights) so your README looks more visually engaging?
