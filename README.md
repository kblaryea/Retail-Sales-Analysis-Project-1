# Retail Sales Analysis SQL Project

## Project Overview

**Project Title**: Retail Sales Analysis  
**Level**: Beginner  
**Database**: `sql_project_P1`

This project is designed to demonstrate SQL skills and techniques typically used by data analysts to explore, clean, and analyze retail sales data. The project involves setting up a retail sales database, performing exploratory data analysis (EDA), and answering specific business questions through SQL queries. This project is ideal for those who are starting their journey in data analysis and want to build a solid foundation in SQL.

## Objectives

1. **Set up a retail sales database**: Create and populate a retail sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `sql_project_P1`.
- **Table Creation**: A table is created and named `retail_sales` to store the sales data. The table structure includes the following columns; transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

```sql
--Creatiing database
Create Database sql_project_P1

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
```

### 2. Data Exploration & Cleaning

- **Record Count**: Determine the total number of records in the dataset.
- **Customer Count**: Find out how many unique customers are in the dataset.
- **Category Count**: Identify all unique product categories in the dataset.
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.

```sql
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
```
#### Remarks

1. The table contains a total of 1,997 data entries.
2. A total of 155 unique customers have made purchases from the store.
3. The products are categorized into three distinct groups: Electronics, Clothing, and Beauty.

### 3. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:

1. **Write a SQL query to retrieve all columns for sales made on '2022-11-05**:
```sql
select *
from retail_sales
where sale_date = '2022-11-05';
```

2. **Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022**:
```sql
Select *
from retail_sales
where category = 'Clothing' 
	and 
	to_char(sale_date, 'YYYY-MM') = '2022-11'
	and quantity >= 4;
```

3. **Write a SQL query to calculate the total sales (total_sale) for each category.**:
```sql
Select category, 
	sum(total_sale) as Total_Cat_Sale, 
	count(*) as total_orders
from retail_sales
group by category
order by Total_Cat_Sale;
```

4. **Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.**:
```sql
Select 
	category, 
	round(avg(age), 0)
from retail_sales
group by category;

-- Alternatively

Select round(avg(age), 0)
from retail_sales
where category = 'Beauty';
```

5. **Write a SQL query to find all transactions where the total_sale is greater than 1000.**:
```sql
select *
from retail_sales
where total_sale > 1000;
```

6. **Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.**:
```sql
select
	category,
	gender,
	count (transactions_id) as total_transactions
from retail_sales
group by 
	category,
	gender
order by category;
```

7. **Write a SQL query to calculate the average sale for each month. Find out best selling month in each year**:
```sql
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

-- Alternatively


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
```

8. **Write a SQL query to find the top 5 customers based on the highest total sales **:
```sql
Select 
	customer_id,
	sum (total_sale) as total_purchase
from retail_sales
group by customer_id

order by total_purchase desc
limit 5;
```

9. **Write a SQL query to find the number of unique customers who purchased items from each category.**:
```sql
Select
	category,
	count( distinct customer_id) as num_of_customers
from retail_sales
group by 
	category
order by
	num_of_customers desc;

```

10. **Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**:
```sql
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
```

## Findings

- **Sales and Order Summary by Product Category**: The data shows that Electronics led in total sales with $313,810 from 684 orders, while Clothing had the highest number of orders at 701, generating $311,070 in sales. Beauty recorded the lowest figures with $286,840 in sales from 612 orders. Overall, sales and order volumes were relatively balanced across categories, with Electronics slightly outperforming in revenue.
  ![021b0dd8-1c0a-424d-8c5b-f5f284a034e8](https://github.com/user-attachments/assets/66d8dd1e-1498-43b6-9eef-6afeac1abd80)


- **Average Age of Customers by Product Category**: The data reveals that customers who purchase Electronics and Clothing have an average age of 42, while those buying Beauty products tend to be slightly younger, with an average age of 40. This suggests a consistent age demographic for Electronics and Clothing, with Beauty products appealing to a marginally younger audience.![eb8970fb-836d-4d0e-bc50-26f97b4afaca](https://github.com/user-attachments/assets/5852b9fe-df64-487f-afb1-66dfcf4958ec)


- **Transaction Distribution by Gender Across Product Categories**: The transaction data reveals a relatively balanced purchasing behavior between male and female customers across all product categories. In the Beauty category, females made slightly more transactions (330) than males (282). For Clothing, transactions are nearly even, with males at 354 and females at 347. In the Electronics category, both genders again show similar engagement, with males accounting for 344 transactions and females for 340. This suggests that gender differences in transaction volume are minimal across product types.
![74b4945a-dd01-4cc2-81b6-d3edf39410ce](https://github.com/user-attachments/assets/fa465f7c-1a0f-4ac6-8c7d-b924dca6b23c)



- **Monthly Average Sales Analysis for 2022–2023**: This dataset outlines the average sales figures across each month from January 2022 to December 2023. In 2022, the average sale peaked in July at approximately $541, while the lowest was in February at around $366. The year 2023 saw a high in February at $535, followed by a general downward trend, ending the year with a lower average in December. This trend may reflect seasonal purchasing behaviors or changes in consumer demand over time.

![95a03b78-66b9-401a-b567-316a7484cff0](https://github.com/user-attachments/assets/f06611d0-0f60-4b9b-9932-7ac8e2d5ba9b)

## Reports

- **Sales Summary**: A detailed report summarizing total sales, customer demographics, and category performance.
- **Trend Analysis**: Insights into sales trends across different months and shifts.
- **Customer Insights**: Reports on top customers and unique customer counts per category.

### **4-Point Report on Retail Sales Data**

1. **Customer Insights**:
   - The company has a diverse customer base, with a significant number of unique customers purchasing across various product categories. For example, the query analyzing unique customers per category highlights which categories attract the most customers, helping identify popular product lines.

2. **Sales Performance**:
   - The data reveals total sales performance by category and identifies high-value transactions. This information can be used to focus on high-performing categories and optimize inventory for products generating the most revenue.

3. **Time-Based Trends**:
   - The analysis of sales by shift and average monthly sales provides insights into customer purchasing behavior over time. For instance, identifying the best-selling months and busiest shifts can help optimize staffing and marketing efforts.

4. **Top Customers and Demographics**:
   - The query identifying the top 5 customers by total sales highlights the most valuable customers, enabling targeted loyalty programs. Additionally, demographic insights, such as the average age of customers in specific categories, can guide personalized marketing strategies.

This analysis provides actionable insights into customer behavior, sales trends, and operational efficiency, helping the company make data-driven decisions.



## Conclusion

This project serves as a comprehensive introduction to SQL for data analysts, covering database setup, data cleaning, exploratory data analysis, and business-driven SQL queries. The findings from this project can help drive business decisions by understanding sales patterns, customer behavior, and product performance.



