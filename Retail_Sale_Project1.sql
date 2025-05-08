--SQL Retail Sale  Analysis Project 1

create DATABASE sql_project_p2;


--Creating Table
Drop table if exists retail_sales;
Create TABLE retail_sales(
            transactions_id int Primary Key,
            sale_date Date,
            sale_time time, 
            customer_id int,
            gender varchar (15),
            age int,	
            category varchar(15),
            quantity int,
    		price_per_unit float,
            cogs float,
            total_sale float 
);
 


select * from retail_sales
limit 100;

Select count(*)
from retail_sales;


select *
from retail_sales
where transactions_id is null
or sale_date is null
or sale_time is null
or gender is null
or age is null
or category is null
or quantity is null
or price_per_unit is null
or cogs is null
or total_sale is null;





--Deleting entries with null values
Delete from retail_sales
where transactions_id is null
or sale_date is null
or sale_time is null
or gender is null
or category is null
or quantity is null
or price_per_unit is null
or cogs is null
or total_sale is null;


-- DATA EXPLORATION

--1. How Many Sales Does the Company Have?
select count(*) as total_sales from retail_sales;

--2. How Many Unique Customers Does the Company Have?
select count (distinct customer_id) as number_of_cusomers
from retail_sales;

--3. How Many Unique Product Category Does the Company Have?
select count (distinct category) as number_of_categories
from retail_sales;

--4. What are the Diofferent Product Categories?
select distinct category
from retail_sales;


--DATA ANALYSIS BUSINESS KEY PROBLEMS AND ANSWERS

--Q1. Write an SQL query to retrieve all columns for sales made on '2022-11-05'

select *
from retail_sales
where sale_date = '2022-11-05';

--Q2. Write a SQL query to retreive all transactions where the category is 'clothing' 
--and the quantity sold is more than 4 in the month of Nov-2022. 

Select *
from retail_sales
where category = 'Clothing' 
	and 
	to_char(sale_date, 'YYYY-MM') = '2022-11'
	and quantity >= 4;
	
--Q3. Write a SQL query to calculate the total sales (total_sale) for each category

Select category, 
	sum(total_sale) as Total_Cat_Sale, 
	count(*) as total_orders
from retail_sales
group by category
order by Total_Cat_Sale;


--Q4. Write a SQL query to find the average age of customers who 
-- purchased items from the 'Beauty' category.

select 
	category, 
	round(avg(age), 0)
from retail_sales
group by category;

--or

select round(avg(age), 0)
from retail_sales
where category = 'Beauty';


--5. Write an SQL query to find all transactions where the total_sale is greater than 1000. 

select *
from retail_sales
where total_sale > 1000;

--6. Write a SQL query to find the total number of transactions (transactions_id) 
-- made by each gender in each category. 

select
	category,
	gender,
	count (transactions_id) as total_transactions
from retail_sales
group by 
	category,
	gender
order by category;


--7. Write a SQL query to calculate the average sale for each month. 
--Find out best selling month in each year.


Select 
	avg_month_sale.month,
	avg_month_sale.year,
	avg(total_sale) as avg_sale
From
(
Select 
	extract (month from sale_date) as month,
	extract (year from sale_date) as year,
	sale_date,
	total_sale
From 
	retail_sales) as avg_month_sale
group by
	avg_month_sale.year,
	avg_month_sale.month

order by 
	avg_month_sale.year,
	avg_sale desc

Select *
From
(
Select 
	extract (month from sale_date) as month,
	extract (year from sale_date) as year,
	avg(total_sale) as avg_sale,
	rank () over (partition by extract (year from sale_date) order by avg(total_sale) desc) as rank
From 
	retail_sales
group by
	year,
	month
	) as t1
where rank = 1;

--OR 


Select 
	extract (month from sale_date) as month,
	extract (year from sale_date) as year,
	avg(total_sale) as avg_sale
From 
	retail_sales
group by
	year,
	month
order by 
	year,
	avg_sale desc;


--Q8. Write an SQL query to find the top 5 customers based on the highest total sales. 

Select 
	customer_id,
	sum (total_sale) as total_purchase
from retail_sales
group by customer_id

order by total_purchase desc
limit 5;


--Q9. Write a SQL query to find the number of unique customers who purchased 
-- items from each categgory

Select
	category,
	count( distinct customer_id) as num_of_customers
from retail_sales
group by 
	category
order by
	num_of_customers desc;
	
	
--Q10. Write an SQL query to create each shift and number of orders (Example morning <=12, 
-- Afternoon Between 12 & 17, Evening >17)

Select 
	t1.shift,
	count(t1.transactions_id) as total_orders
From
(
Select
	*,
Case
	when extract(hour from sale_time) < 12 then 'Morning'
	when extract(hour from sale_time) >= 12 and extract(hour from sale_time) <= 17 then 'Afternoon'
	else 'Evening'
End as Shift
From 
	retail_sales) as t1
	
Group by t1.shift
order by total_orders desc;

--End of Project



	




