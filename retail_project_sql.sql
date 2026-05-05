CREATE TABLE orders (
    Order_ID VARCHAR(10),
    Order_Date DATE,
    Customer_ID VARCHAR(10),
    Product_ID VARCHAR(10),
    Quantity INT,
    Sales FLOAT,
    Discount FLOAT,
    Profit FLOAT
);

CREATE TABLE customers (
    Customer_ID VARCHAR(10),
    Customer_Name VARCHAR(50),
    Region VARCHAR(20),
    Segment VARCHAR(20)
);

CREATE TABLE products (
    Product_ID VARCHAR(10),
    Product_Name VARCHAR(50),
    Category VARCHAR(30),
    Sub_Category VARCHAR(30)
);

 CREATE TABLE returns (
    Order_ID VARCHAR(10),
    Returned VARCHAR(5)
);


select * from orders;
select * from customers;
select * from products;
select * from returns;


--Total Sales by Region

select c.region,sum(o.sales) as total_sales
from orders o 
join customers c 
on o.customer_id=c.customer_id
group by c.region
;


--Top 5 Customer by Sales

select c.customer_name,sum(o.sales) as total_sales
from orders o 
join customers c 
on o.customer_id=c.customer_id
group by c.customer_name 
order by total_sales desc
limit 5;

--Monthly sales Trend

select extract(month from order_Date) as months,
sum(sales) as total_Sales
from orders
group by months
order by months;


--Category wise Profit

select p.category,sum(o.profit) as total_profit
from orders o 
join products p on
o.product_id=p.product_id
group by p.category
order by total_profit;

--Find Orders With Loss

select * from orders
where profit <0;

--Sales by Segement

select c.segment,sum(o.sales) as total_sales
from orders o 
join customers c 
on c.customer_id=o.customer_id
group by c.segment
order by total_Sales;

--Top Product in Each Category

select * from(
select p.product_name,p.category,
sum(o.sales) as total_sales,
rank() over(partition by p.category order by sum(o.sales) desc) as rnk
from orders o 
join products p 
on o.product_id= p.product_id
group by p.category,p.product_name
)t
where rnk=1;

--Average order Value
select avg(sales) as avg_sales
from orders;


--customers with no returns

select distinct c.customer_name
from customers c 
left join orders o on c.customer_id=o.customer_id
left join returns r on r.order_id=o.order_id
where r.returned is null or r.returned='No';


--Region with Highest Profit
select c.region,sum(o.profit) as total_profit
from customers c 
join orders o on c.customer_id=o.customer_id
group by c.region 
order by total_profit desc
limit 1;

--Most Returned Product 

select p.product_name,count(*) as return_count
from returns r 
join orders o on r.order_id=o.order_id
join products p on p.product_id=o.product_id
where r.returned ='Yes'
group by p.product_name
order by return_count desc;



--Running Total of Sales 

select order_id,sales,
sum(sales) over(order by order_id) as running_total
from orders;

