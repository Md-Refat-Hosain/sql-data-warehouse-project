-- ==============================================================================
-- PURPOSE:  This part of the project I have applied data analysis formuals via SQL 
-- Understand the the dataset very well.

-- ==============================================================================

select * from gold.fact_sales;
select * from gold.dim_products;
select * from gold.dim_customer;
--- Database Exploration ---
-- ## Explore all the tables -- ##

select * from information_schema.tables
order by table_schema

-- ## Explore all the columns -- ##

select * from information_schema.columns
where table_schema in ('bronze' , 'silver' , 'gold')
order by table_schema,table_name,ordinal_position


--- Dimension Exploration ---


-- ## Explore all  countries -- ##

select count (country ) , country
from gold.dim_customer
group by country

-- ## Explore all  the categories by 'The major Divisions' -- ##
select distinct category , sub_category, product_name  from gold.dim_products
order by 1,2,3

--- Date Exploration ---

--- ## Find the first & Last date --##

select max(order_date) , min(order_date)
from gold.fact_sales

--- ## how many years of sales are available --##


select max(order_date) , min(order_date) , extract( year from max(order_date) ) - extract( year from min(order_date) )
from gold.fact_sales

--- ## Find the yongest & oldest customer --##

select min(birth_date) min_birth_date, max(birth_date) max_birth_date , 
extract ( year from age(min(birth_date) )) as oldest_age , extract(year from age(max(birth_date)) ) youngest_age

from gold.dim_customer

--- Mesure Exploration ---
-- ## Find the total sales --##

select sum(sales_amount) 
from gold.fact_sales

-- ## how many items sold--##
select sum(quantity)
from gold.fact_sales

-- ## Average selling price --##
select avg(price)
from gold.fact_sales

-- ## Find the total numbers of orders -- ##

select count(order_number) as total_orders
from gold.fact_sales

select count( distinct order_number) total_orders
from gold.fact_sales
