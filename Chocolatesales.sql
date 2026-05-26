CREATE TABLE calender (
    c_date      DATE,
    year        NUMBER,
    month       NUMBER,
    day         NUMBER,
    week        NUMBER,
    day_of_week NUMBER
);

Select * from calender
Fetch first 10 rows only;        

desc calender;

Select * from customer
Fetch first 15 rows only; 

Select * from sales
Fetch first 15 rows only; 

Select * from stores
Fetch first 15 rows only; 

--questions--
--1. Total Sales Revenue
--2. Total Quantity of Chocolates Sold
--3. Number of Unique customers
--4. Top 10 customers by Sales
--5.Sales by Store
--6. Sales by Country
--7. Monthly Sales Trend
--8. Yearly Sales
--9. Best Selling Chocolate Product
--10. Average Order Value
--11. Store with Highest Sales
--12. Sales per customer
--13. Monthly Sales per Store
--14. Top 5 Products by Revenue 
--15. Customer Purchase Frequency
--16. Rank Stores by Sales
--17. Top 3 Customers per store
--18. Running Total Sales by Month
--19. Total Profit
--20. Profit by Store
--21. Average Discount Given
--22. Total Orders per Store
--23. Profit Margin by Product
--24. Sales with Discount Applied
--25. Which store type generates the highest sales?

SELECT round(SUM(revenue), 2) AS "Total Sales"
FROM sales;

SELECT SUM(quantity) AS "Total Quantity"
FROM sales;

SELECT COUNT(DISTINCT customer_id) AS Unique_customers
FROM sales;

SELECT COUNT(customer_id) AS Customer_id
FROM sales;

SELECT
    customer_id,
    store_id,
    SUM(revenue) AS total_profit
FROM
    sales
GROUP BY
    customer_id,
    store_id
ORDER BY
    total_profit DESC
FETCH FIRST 10 ROWS ONLY;

SELECT
    si.store_id,
    si.country,
    SUM(s.revenue) AS Total_sales_by_store
FROM
         sales s
    JOIN stores si ON s.store_id = si.store_id
GROUP BY
    si.store_id,
    si.country
ORDER BY
   Total_sales_by_store DESC
   FETCH FIRST 10 ROWS ONLY;


select c.country, sum(s.revenue) AS total_sales_by_country
from sales s join stores c on s.store_id = c.store_id 
group by c.country order by total_sales_by_country desc;

select * from stores;
select * from sales;


SELECT
    m.month,
    SUM(s.revenue) AS monthly_sales
FROM
         calender m
    JOIN sales s ON m.c_date = s.order_date
GROUP BY
    m.month
ORDER BY
    m.month ASC; 

SELECT
    y.year,
    SUM(r.revenue) AS yearly_sales
FROM
    calender y
    JOIN sales r ON y.c_date = r.order_date
GROUP BY
    y.year;

SELECT
    product_id,
    SUM(quantity) AS total_quantity
FROM
    sales
GROUP BY
    product_id
ORDER BY
    total_quantity DESC
FETCH FIRST 1 ROW ONLY;

SELECT 
Round(AVG(revenue),2) AS average_value
FROM sales;

SELECT
    s.store_name,
    SUM(o.revenue) AS highest_sales
FROM
    stores s
    JOIN sales o ON s.store_id = o.store_id
GROUP BY
    s.store_name
ORDER BY
     highest_sales desc
    fetch first 5 rows only;
    
select customer_id, sum(revenue) as sales_per_customer
from sales
group by customer_id
order by sales_per_customer  
fetch first 12 rows only;


select m.month, sum(r.revenue) AS Monthly_sales, r.store_id, e.store_name
from calender m
join sales r
on m.c_date = r.order_date
join stores e
on e.store_id = r.store_id
group by m.month, r.store_id, e.store_name
order by Monthly_sales desc
fetch first 12 rows only;



select product_id, sum(revenue) AS Revenue_by_product
from sales
group by product_id
order by Revenue_by_product desc
fetch first 5 rows only;


select customer_id, product_id, count(order_id)  AS Purchase_frequency
from sales
group by customer_id, product_id
order by Purchase_frequency desc
fetch first 15 rows only;



Select store_id, sum(revenue) as Total_Sales,
Dense_rank() over (order by sum(revenue) desc ) AS sales_rank from sales
group by store_id
fetch first 10 rows only;


select * from 
(Select customer_id, store_id, sum(revenue) AS total_sales,
Dense_rank() over (partition by store_id order by sum(revenue) ) AS Cust_rank from Sales
group by customer_id, store_id)
where Cust_rank  <=3 
fetch first 11 rows only;


Select c.month, sum(s.revenue) as total_sales,
sum(sum(s.revenue) )over (order by c.month ) As Running_total
from Calender c
join sales s on s.order_date= c.c_date
group by c.month ;


SELECT * FROM sales;


select sum(profit)as Total_profit from sales;


select store_id, sum(profit)as Total_profit from sales
group by store_id order by Total_profit desc
fetch first 11 rows only;

Select round(avg(discount),2) as Average_discount from sales;

select store_id, count(order_id) as Total_order from sales
group by store_id order by Total_order asc
fetch first 15 rows only;

select product_id, round(sum(profit) / sum(revenue)*100,2) as profit_margin
from sales group by product_id order by profit_margin desc
fetch first 15 rows only;


select  product_id, discount from sales where discount > 0
fetch first 10 rows only;


Select s.store_type, sum(r.revenue) as Total_sales from sales r
join stores s on r.store_id = s.store_id 
group by s.store_type order by sum(r.revenue) desc;

--Dataset
Select s.order_id, s.product_id, s.quantity, s.revenue, s.discount, s.profit, c.customer_id, st.country, st.store_type, st.store_name, st.store_id, cal.year, cal.month from sales s 
join customer c on s.customer_id = c.customer_id
join  stores st on s.store_id = st.store_id
join calender cal on cal.c_date = s.order_date;
