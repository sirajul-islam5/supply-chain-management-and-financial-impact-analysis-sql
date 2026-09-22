CREATE DATABASE supply_chain_db;

USE supply_chain_db;

SELECT * 
FROM products;
## Normalizing Data Types of products 
ALTER TABLE products
	MODIFY unit_cost DECIMAL(10,2),
    MODIFY unit_price DECIMAL(10,2);
    
SELECT *
FROM orders;
## Normalizing Data Types of orders 
ALTER TABLE orders
	MODIFY order_date DATE,
    MODIFY sales_amount DECIMAL(20,2),
    MODIFY shipping_cost DECIMAL(10,2);
    
SELECT * FROM customers;
SELECT * FROM orders;
SELECT * FROM products;
SELECT * FROM suppliers;

DESCRIBE customers;
DESCRIBE orders;
DESCRIBE products;
DESCRIBE suppliers;


-- ##### DATA ANALYSIS ##### -- 
-- ## Sales and Customer Performance Analysis ## -- 
SELECT * FROM customers;
SELECT * FROM orders;
-- Note: Common Column = Customer_ID


## Which customer types generate the most revenue? 
SELECT * FROM customers;
SELECT * FROM orders;

SELECT cus.Customer_Type, SUM(ord.sales_amount) AS total_sales_amount
FROM customers AS cus
INNER JOIN orders AS ord
	ON cus.Customer_ID = ord.Customer_ID 
GROUP BY cus.Customer_Type
ORDER BY total_sales_amount DESC; 
-- The institutional customers generate the most revenue 


## Which industries generate the highest revenue?
SELECT * FROM customers;
SELECT * FROM orders;

SELECT cus.Industry, SUM(ord.sales_amount) AS total_sales_amount
FROM customers AS cus
INNER JOIN orders AS ord
	ON cus.Customer_ID = ord.Customer_ID
GROUP BY cus.Industry 
ORDER BY total_sales_amount DESC;
-- The automotive industry generates the highest revenue and 
-- The construction industry generates the lowest revenue 


## Top 2 US regions with highest sales: 
SELECT * FROM customers;
SELECT * FROM orders;

SELECT cus.Region, SUM(ord.sales_amount) AS total_sales_amount
FROM customers AS cus 
INNER JOIN orders AS ord
	On cus.Customer_ID = ord.Customer_ID
GROUP BY cus.Region 
ORDER BY total_sales_amount DESC;
-- South and Midwest are the top 2 regions with highes sales 
-- Northeast region generates the lowest sales 


## Overall Business Performance: 
-- Total Sales, Maximum Sales Amount, Minimum Sales Amount, Total Sales Amount 
SELECT * FROM customers;
SELECT * FROM orders;

SELECT 
	COUNT(ord.Order_ID) AS total_sales, 
    MAX(ord.sales_amount) AS maximum_sales_amount,
	MIN(ord.sales_amount) AS minimum_sales_amount, 
    SUM(ord.sales_amount) AS total_sales_amount
FROM customers AS cus
INNER JOIN orders AS ord
	ON cus.Customer_ID = ord.Customer_ID;
-- Total Sales = 15250 
-- Maximum Sales Amount = 88720.19 
-- Minimum Sales Amount = 6.30 
-- Total Sales Amount = 118005124.31 


-- ## Product Performance Analysis ## -- 
SELECT * FROM orders;
SELECT * FROM products;
-- Note: Common Column = Product_ID


## Which 3 product categories generate the most revenue?
SELECT * FROM orders;
SELECT * FROM products;

SELECT pro.Category, SUM(ord.sales_amount) AS total_sales_amount
FROM orders AS ord
INNER JOIN products AS pro
	ON ord.Product_ID = pro.Product_ID
GROUP BY pro.Category
ORDER BY total_sales_amount DESC;
-- Top 3 best selling product categories are: 
-- 1. Cleaning & Facility, 2. Packaging & 3. Tools


## Which product generate the highest gross profit?
SELECT * FROM orders;
SELECT * FROM products;

SELECT 
	pro.Product_Name, 
    SUM(ord.sales_amount) AS total_sales_amount,
    SUM(ord.Quantity * pro.unit_cost) AS total_cost,
    SUM(ord.sales_amount) - SUM(ord.Quantity * pro.unit_cost) AS gross_profit
FROM orders AS ord 
INNER JOIN products AS pro
	ON ord.Product_ID = pro.Product_ID
GROUP BY pro.Product_Name
ORDER BY gross_profit DESC;
-- Multi-Pack Impact Wrench - 1089 lb (Product) generates the highest gross profit


-- ## Supplier Performance Analysis ## --
SELECT * FROM orders;
SELECT * FROM products;
-- Note: Common Column = Product_ID
SELECT * FROM products;
SELECT * FROM suppliers;
-- Note: Common Column = Supplier_ID 


## Which suppliers are associated with highest total product cost?
SELECT * FROM orders;
SELECT * FROM products;
SELECT * FROM suppliers;

SELECT sup.Supplier_Name, SUM(pro.unit_cost) AS total_cost
FROM products AS pro
INNER JOIN suppliers AS sup
	ON pro.Supplier_ID = sup.Supplier_ID
GROUP BY sup.Supplier_Name
ORDER BY total_cost DESC;
-- Titan Systmes Inc. (Suppliers Name) is associated with highest total product cost 
-- And the cost is 7969.99 


## Which supplier's products generate highest sales? 
SELECT * FROM orders;
SELECT * FROM products;
SELECT * FROM suppliers;

SELECT sup.Supplier_Name, SUM(ord.sales_amount) AS total_sales_amount
FROM suppliers AS sup
INNER JOIN products AS pro
	ON sup.Supplier_ID = pro.Supplier_ID
INNER JOIN orders AS ord
	ON pro.Product_ID = ord.Product_ID
GROUP BY sup.Supplier_Name 
ORDER BY total_sales_amount DESC;
-- MIdwest Manufacturing Co. is the supplier with highest sales 


-- ## Supply Chain and Financial Imact Analysis ## -- 
SELECT * FROM customers;
SELECT * FROM orders;
SELECT * FROM products;
SELECT * FROM suppliers;
## Which delivery status occurs most frequently? 
SELECT Delivery_Status, COUNT(*) AS total
FROM orders
GROUP BY Delivery_Status; 
-- 'On Time' occurs most frequently 


# Backup Script 
SELECT Delivery_Status, COUNT(*) AS total
FROM orders
GROUP BY Delivery_Status
LIMIT 1
OFFSET 1; 

SELECT * FROM customers;
SELECT * FROM orders;
SELECT * FROM products;
SELECT * FROM suppliers;
## Which customer regions experienced the most delayed status?
SELECT cus.Region, COUNT(*) AS delayed_status
FROM customers AS cus
INNER JOIN orders AS ord
	ON cus.Customer_ID = ord.Customer_ID
WHERE ord.Delivery_Status = 'Delayed'
GROUP BY cus.Region
ORDER BY delayed_status DESC;


SELECT * FROM customers;
SELECT * FROM orders;
SELECT * FROM products;
SELECT * FROM suppliers;
## Which products have highest shipping cost?
SELECT pro.Product_Name, SUM(ord.shipping_cost) AS total_shipping_cost
FROM products AS pro
INNER JOIN orders AS ord
	ON pro.Product_ID = ord.Product_ID
GROUP BY pro.Product_Name     
ORDER BY total_shipping_cost DESC;
-- Multi-Pack Impact Wrench - 1089 lb (Product) has highest shipping cost 
-- The cost is 168180.31 


SELECT * FROM customers;
SELECT * FROM orders;
SELECT * FROM products;
SELECT * FROM suppliers;
## Which shipping categories should management investigate?
SELECT * FROM orders;
SELECT 
	AVG(shipping_cost),
    MAX(shipping_cost),
    MIN(shipping_cost)
FROM orders;
-- 
SELECT * FROM orders;
-- 
SELECT 
	CASE
		WHEN shipping_cost >= 700 THEN 'High Shipping Cost'
        WHEN shipping_cost <= 200 THEN 'Low Shipping Cost'
        ELSE 'Average Shipping Cost'
    END AS shipping_category,
    COUNT(*) AS order_count,
    SUM(sales_amount) AS total_sales_in_category
FROM orders
GROUP BY shipping_category
ORDER BY order_count;
-- Low Shipping Cost Category ==> order_count highest but total_sales lowest 
-- So, Management should investigate the product of low shipping cost category 

 
SELECT * FROM customers;
SELECT * FROM orders;
SELECT * FROM products;
SELECT * FROM suppliers;
## Which product categories have the highest sales amount? 
SELECT pro.Category, SUM(sales_amount) AS total_sales_amount
FROM products AS pro 
INNER JOIN orders AS ord 
	ON pro.Product_ID = ord.Product_ID
GROUP BY pro.Category 
ORDER BY total_sales_amount DESC; 
-- Cleaning & Facility (Category) has the highest sales amount 

SELECT * FROM customers;
SELECT * FROM orders;
SELECT * FROM products;
SELECT * FROM suppliers;
-- ## KPI Analysis ## -- 
-- 
# Total Sales Amount 
SELECT SUM(sales_amount) AS total_sales_amount
FROM orders;
-- 
# Total Shipping Cost 
SELECT SUM(shipping_cost) AS total_shipping_cost
FROM orders;
-- 6262727.64 
# Product Category with Gross Profit 
SELECT 
	pro.Category,
    SUM(ord.sales_amount) AS total_sales_amount, 
    SUM(pro.unit_cost * ord.Quantity) AS total_cost, 
    SUM(ord.sales_amount) - SUM(pro.unit_cost * ord.Quantity) AS gross_profit
FROM products AS pro
INNER JOIN orders AS ord
	ON pro.Product_ID = ord.Product_ID 
GROUP BY pro.Category 
ORDER BY gross_profit DESC;
-- 5854835.56
-- Packaging 
# City with Highest Sales Amount 
SELECT * FROM orders;
SELECT * FROM customers;
SELECT 
	cus.City, 
    SUM(ord.sales_amount) AS total_sales_amount
FROM customers AS cus
INNER JOIN orders AS ord 
	ON cus.Customer_ID = ord.Customer_ID
GROUP BY cus.City
ORDER BY total_sales_amount DESC;
-- Atlanta
# Region with Highest Gross Profit
SELECT * FROM customers;
SELECT * FROM orders;
SELECT * FROM products;
SELECT 
	cus.Region, 
    SUM(ord.sales_amount) AS total_sales_amount,
    SUM(ord.Quantity * pro.unit_cost) AS total_cost,
    SUM(ord.sales_amount) - SUM(ord.Quantity * pro.unit_cost) AS gross_profit
FROM customers AS cus
INNER JOIN orders AS ord
	ON cus.Customer_ID = ord.Customer_ID 
INNER JOIN products AS pro 
	ON pro.Product_ID = ord.Product_ID
GROUP BY cus.Region 
ORDER BY gross_profit DESC;
-- South Region 


SELECT * FROM customers;
SELECT * FROM orders;
SELECT * FROM products;
SELECT * FROM suppliers;
## Which products should management investigate based on financial impact?
SELECT 
	pro.Category, 
    SUM(ord.sales_amount) AS total_sales_amount,
    SUM(ord.Quantity) AS total_quantity, 
    SUM(ord.shipping_cost) AS total_shipping_cost
FROM products AS pro
INNER JOIN orders AS ord
	ON pro.Product_ID = ord.Product_ID
GROUP BY pro.Category 
ORDER BY total_sales_amount, total_quantity, total_shipping_cost;
-- Management should investigate 'Electrical' products based on financial impact


SELECT * FROM customers;
SELECT * FROM orders;
SELECT * FROM products;
SELECT * FROM suppliers;
## Which customer segments have high sales but relatively high shipping cost? 
SELECT 
	cus.Customer_Type, 
    SUM(ord.sales_amount) AS total_sales_amount,
    SUM(ord.shipping_cost) AS total_shipping_cost
FROM customers AS cus
INNER JOIN orders AS ord 
	On cus.Customer_ID = ord.Customer_ID 
GROUP BY cus.Customer_Type 
ORDER BY total_sales_amount DESC, total_shipping_cost DESC;
-- Institional customers have high sales and also high shipping cost


-- ##### THE END OF ANALYSIS ##### -----  






