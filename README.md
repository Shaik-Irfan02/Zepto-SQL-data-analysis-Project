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
```
## 🔍 Key Highlights

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

## 📈 Example Query

Top 10 best-value products:

```
SELECT name, mrp, discountPercent
FROM (
    SELECT name, mrp, discountPercent,
           ROW_NUMBER() OVER (ORDER BY discountPercent DESC) AS rn
    FROM zepto
) ranked
WHERE rn <= 10;
```

Top 5 products per category by discount:

```sql
SELECT category, name, discountPercent
FROM (
    SELECT category, name, discountPercent,
           ROW_NUMBER() OVER (
               PARTITION BY category ORDER BY discountPercent DESC
           ) AS rn
    FROM zepto
) ranked
WHERE rn <= 5;

```
## 🚀 Insights

- Window functions enable ranking, cumulative totals, and comparisons without collapsing rows.
- PARTITION BY resets calculations per category, making category‑wise analysis possible.
- The dataset highlights best‑value products, stock trends, and discount contributions across categories.

## 🏁 Conclusion
This project demonstrates how SQL can be used for **data cleaning, exploration, and advanced analytics** on retail datasets.  
By applying **Window Functions** (`ROW_NUMBER`, `RANK`, `DENSE_RANK`, `SUM`, `MAX`) along with **PARTITION BY**, we were able to:

- Rank products overall and within categories by discount percentage.
- Identify the highest discounted products per category.
- Calculate cumulative stock availability and inventory weight.
- Measure each product’s contribution to category discounts.
- Derive actionable insights into pricing, stock trends, and category performance.

This analysis highlights the power of SQL for **business intelligence and decision-making**, showing how raw data can be transformed into meaningful insights.

---

## 👨‍💻 Author
Developed by **Irfan Shaik**  
Focus: SQL Analytics, Window Functions, and Retail Data Insights  

🔗 [Github Profile]((https://github.com/Shaik-Irfan02))
🔗 [LinkedIn Profile](https://www.linkedin.com/in/shaik-irfan02)



