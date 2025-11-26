KPI QUERIES (Top Row of Dashboard)
**1. Total Sales = 53M**

SELECT SUM(sales_amount) AS total_sales
FROM sales;

2. Total Orders = 1000
SELECT COUNT(DISTINCT order_id) AS total_orders
FROM sales;

3. Average Order Value = 53K
SELECT 
    SUM(sales_amount) / COUNT(DISTINCT order_id) AS avg_order_value
FROM sales;

4. Total Customers = 199
SELECT COUNT(DISTINCT customer_id) AS total_customers
FROM customers;

5. Single Order Customers = 6
WITH t AS (
    SELECT customer_id, COUNT(order_id) AS order_count
    FROM sales
    GROUP BY customer_id
)
SELECT COUNT(*) AS single_order_customers
FROM t
WHERE order_count = 1;

6. Purchase Frequency = 5.03
SELECT 
    COUNT(order_id) * 1.0 / COUNT(DISTINCT customer_id) AS purchase_frequency
FROM sales;

TREND ANALYSIS
7. Total Sales by Year, Month and Day

(Used in the yellow line chart)

SELECT 
    order_date,
    SUM(sales_amount) AS daily_sales
FROM sales
GROUP BY order_date
ORDER BY order_date;

8. Sum of Return ID by Year, Quarter, Month and Day
SELECT 
    return_date,
    COUNT(return_id) AS total_returns
FROM returns
GROUP BY return_date
ORDER BY return_date;

REGION-WISE SALES CHART
9. Total Sales by Region
SELECT 
    region,
    SUM(sales_amount) AS total_sales
FROM sales
GROUP BY region
ORDER BY total_sales DESC;

CUSTOMER AGE ANALYSIS
10. Sum of Sales by Age Group (Pie Chart)
SELECT 
    CASE 
        WHEN age < 25 THEN '<25'
        WHEN age BETWEEN 25 AND 34 THEN '25-34'
        WHEN age BETWEEN 35 AND 44 THEN '35-44'
        ELSE '45+'
    END AS age_group,
    SUM(s.sales_amount) AS total_sales
FROM customers c
JOIN sales s ON c.customer_id = s.customer_id
GROUP BY age_group
ORDER BY total_sales DESC;

11. Total Sales by Age Group (Bar Chart)
SELECT 
    CASE 
        WHEN age < 25 THEN '<25'
        WHEN age BETWEEN 25 AND 34 THEN '25-34'
        WHEN age BETWEEN 35 AND 44 THEN '35-44'
        ELSE '45+'
    END AS age_group,
    SUM(sales_amount) AS total_sales
FROM customers c
JOIN sales s ON c.customer_id = s.customer_id
GROUP BY age_group;

PAYMENT METHOD ANALYSIS
12. Sum of Sales by Payment Method
SELECT 
    payment_method,
    SUM(sales_amount) AS total_sales
FROM sales
GROUP BY payment_method
ORDER BY total_sales DESC;

CATEGORY & PRODUCT PERFORMANCE
13. Top 8 Product Categories by Sales
SELECT 
    p.category_name,
    SUM(s.sales_amount) AS total_sales
FROM sales s
JOIN products p ON s.product_id = p.product_id
GROUP BY p.category_name
ORDER BY total_sales DESC
LIMIT 8;

14. Top 5 Products by Sales
SELECT 
    p.product_name,
    SUM(s.sales_amount) AS total_sales
FROM sales s
JOIN products p ON s.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_sales DESC
LIMIT 5;

RETURNS VS ORDERS (Category-wise Line Chart)
15. Sum of Returned Orders & Total Orders by Category
SELECT 
    p.category_name,
    COUNT(r.return_id) AS total_returns,
    COUNT(DISTINCT s.order_id) AS total_orders
FROM products p
LEFT JOIN sales s ON p.product_id = s.product_id
LEFT JOIN returns r ON s.order_id = r.order_id
GROUP BY p.category_name
ORDER BY total_orders DESC;

ADDITIONAL EDA (Optional)

Useful for deeper analysis if needed.

Return Rate by Category
SELECT 
    p.category_name,
    COUNT(r.return_id) AS returned_orders,
    COUNT(DISTINCT s.order_id) AS total_orders,
    (COUNT(r.return_id) * 100.0 / COUNT(DISTINCT s.order_id)) AS return_rate
FROM sales s
JOIN products p ON s.product_id = p.product_id
LEFT JOIN returns r ON s.order_id = r.order_id
GROUP BY p.category_name;

Sales Trend by Category
SELECT 
    p.category_name,
    DATE(order_date) AS dt,
    SUM(sales_amount) AS total_sales
FROM sales s
JOIN products p ON s.product_id = p.product_id
GROUP BY p.category_name, dt
ORDER BY dt;
