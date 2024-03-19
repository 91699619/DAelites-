/* •Write SQL queries to retrieve the total number of orders, customers, and products in the dataset.*/

SELECT 
		COUNT (DISTINCT(Customer_ID)) AS total_customers,
		COUNT (Order_ID) AS total_orders,
		COUNT(DISTINCT(Product_Name)) AS total_products
FROM 
		orders;

/*The total customers is 1130, total products 913 and the total orders is 1952.*/


/* •Calculate and display the total sales, average discount, and profit for each product category.
	Order the results by total sales in descending order.*/

----Solution

SELECT 
		Product_Category,
		ROUND(SUM(Sales), 2) AS total_sales,
		ROUND(AVG(Discount), 3) AS avg_discount,
		ROUND(SUM(Profit), 2) AS profit
		
FROM
		orders
GROUP BY Product_Category
ORDER BY total_sales DESC;
/* Technology product_category has most sales value while Office supplies has the least sales value, though it has the most profit.
And furniture has the least profit.*/



/* •Identify the top 10 customers with the highest total sales.
Calculate the average order value for each customer segment
*/

SELECT TOP 10
		Customer_Name,
		ROUND(SUM(Sales), 2) AS total_sales,
		ROUND(SUM(Profit), 2) AS total_profit,
		COUNT(Product_Name) AS products
		
FROM
		orders
GROUP BY Customer_Name
ORDER BY total_sales DESC;
/* The customer with highest sales is Kristine Connolly and Andrew is 10th highest but Andrew sold most variety of product.*/

---3b. Calculate the average order value for each customer segment
SELECT
		Customer_Segment,
		SUM(Quantity_ordered_new) as total_quantity,
		COUNT(Quantity_ordered_new) as total_orders,
		AVG(Quantity_ordered_new) as avg_order_value
FROM 
		orders
GROUP BY Customer_Segment
ORDER BY avg_order_value DESC;

/* Home Office and Small Business have same average order while Corporporate and Consumer has same*/


/* Analyze the sales trend over time by displaying the monthly sales for each year in the dataset.
Identify the month with the highest sales*/
SELECT 
	DATENAME(MONTH, Order_Date) AS month_order,
    YEAR(Order_Date) AS year_order,
	ROUND(SUM(Sales), 2) AS total_sales
    
FROM 
    orders
GROUP BY DATENAME(MONTH, Order_Date),YEAR(Order_Date)
ORDER BY total_sales DESC;
/* The sales keep alternating increase and decrease over the months
April has the highest sales and March the lowest. */



/*Determine the top 5 best-selling products based on the quantity sold.
Calculate the profit margin for each product and display the results.*/

SELECT
	TOP 5 Quantity_ordered_new,
	Product_Name
FROM
	orders
ORDER BY Quantity_ordered_new DESC;


---Calculate the profit margin for each product and display the results
SELECT 
	 Product_Name,
	Product_Sub_Category,
	ROUND(((Profit / (Sales - Discount)) *100), 2) AS  Profit_Margin
FROM 
orders;





/*	Analyze the impact of discounts on sales and profit.
Calculate the average discount for each product category.*/

SELECT 
Product_Category,
ROUND(AVG(Discount), 4) as Discount_avg,
ROUND(AVG(Sales),2) AS sale_avg,
ROUND(AVG(Profit),2) AS profit_avg,
(ROUND(AVG(Profit),2)/ ROUND(AVG(Sales),2)) * 100 AS percentage_profit
FROM orders
GROUP BY Product_Category;
/* There is no correlation between the discounts, sales and profit*/



-----6b Calculate the average discount for each product category
SELECT 
	Product_Category,
	ROUND(AVG(Discount), 3) AS avg_discount
FROM
orders
GROUP BY Product_Category
ORDER BY Product_Category;

--- Furniture has the highest average discount. which is closely by Office Supplies and the least is Technology.




/*Create a segmentation analysis by dividing customers into different groups based on their total purchases.
Provide insights into the characteristics of each customer group.*/

SELECT 
		Quantity_ordered_new,
		Customer_Name,
CASE WHEN 
		Quantity_ordered_new <= 50 THEN 'low_purchaser'
WHEN 
		Quantity_ordered_new BETWEEN 51 AND 100 THEN 'medium_puchaser'
ELSE	
		'high_purchaser'
END AS	new_customer_segment

FROM 
	orders;
/* The customers were grouped into three categories according to their purchases
Less and equal to 50 are termed 'Low_purchase', Between 51 to 100 are medium_puchaser
Above 100 are termed high_purchaser*/


SELECT 
    COUNT(CASE WHEN Quantity_ordered_new < 50 THEN 1 END) AS Low_Purchaser,
    COUNT(CASE WHEN Quantity_ordered_new >= 50 AND Quantity_ordered_new < 100 THEN  1 END) AS Mid_Purchaser,
    COUNT(CASE WHEN Quantity_ordered_new > 100 THEN 1 END) AS High_Purchaser
   
FROM orders;

--- Only 4 customers bought more than 100 items, Majority bought 50 or less


SELECT *FROM orders;


/* Total sales by Manager and Region*/
SELECT 
    r.Region,
    r.Manager,
    ROUND(SUM(o.Sales),2) AS Total_Sales
FROM 
    orders o
JOIN 
    users r ON o.Region = r.Region

GROUP BY 
    r.Region, r.Manager
ORDER BY Total_Sales DESC;

--The East region with Erin as manager has the highest sales and Sam the South region manager registered the lowest sales for this period.


SELECT 
	ROUND(AVG(Profit) / AVG(Sales) * 100, 3) AS percentage_profit,
	DATENAME(MONTH,Order_Date) AS month_order,
    YEAR(Order_Date) AS year_order,
	ROUND(SUM(Sales), 2) AS total_sales 
FROM 
    orders
GROUP BY DATENAME(MONTH,Order_Date),YEAR(Order_Date)
ORDER BY percentage_profit DESC;
-- The percentage profit for each month, The month of May has the highest and the least is the month of March, also having the lowest sales  