/*
==============================================================================
Here have all kinds of data analytst code
==============================================================================

*/


-- Change over time --

--# By Year
SELECT EXTRACT(YEAR FROM  order_date),
sum(sales_amount) total_sales,
count(distinct customer_key) total_customer,
sum(quantity) as total_quantity
from gold.fact_sales
where order_date is not null 
group by EXTRACT(YEAR FROM  order_date)
order by EXTRACT(YEAR FROM  order_date)

--# By Month


--# By Month & Year together

SELECT 
EXTRACT(year FROM  order_date) order_year,
EXTRACT(month FROM  order_date) order_month,
sum(sales_amount) total_sales,
count(distinct customer_key) total_customer,
sum(quantity) as total_quantity
from gold.fact_sales
where order_date is not null 
group by EXTRACT(year FROM  order_date),EXTRACT(month FROM  order_date)
order by EXTRACT(year FROM  order_date),EXTRACT(month FROM  order_date)


-- Cumulative Analysis --
--# Calculate the total sales per month
select
date_trunc('month',order_date):: date order_date,
sum(sales_amount) total_sales
from gold.fact_sales
group by date_trunc('month',order_date)
order by date_trunc('month',order_date)

--# Calculate the total sales per month
--   and the running total of sales over time
select
order_date,
total_sales,
sum(total_sales) over ( partition by order_date order by order_date) as running_total_sales
from

(select
date_trunc('year',order_date):: date order_date,
sum(sales_amount) total_sales
from gold.fact_sales
group by date_trunc('year',order_date)
order by date_trunc('year',order_date)
)t

-- Performance Analysis --

/* 
Analyze the yearly peroformance of products by comparing their sales
to both the average sales performace of the product and the previous year's sales

*/


with yearly_product_sales as 

(select
extract( 'year' from f.order_date) order_year,
p.product_name,
sum (f.sales_amount) as current_sales
from gold.fact_sales f 
left join gold.dim_products p 
on f.product_key = p.product_key
where order_date is not null
group by extract( 'year' from f.order_date) , 
p.product_name
)
select
order_year,
product_name,
current_sales,
round(avg(current_sales) over(partition by product_name)) avg_sales,
current_sales - round(avg(current_sales) over(partition by product_name)) as diff_avg,
case 
    when current_sales - round(avg(current_sales) over(partition by product_name)) > 0 then 'Above Avg'
    when current_sales - round(avg(current_sales) over(partition by product_name)) < 0 then 'Below Avg'
    else 'Equal'
end as avg_change,
-- year-over-year analysis --
lag(current_sales) over(partition by product_name order by order_year) py_sales,

case 
    when current_sales - lag(current_sales) over(partition by product_name order by order_year) > 0 then 'Increase'
    when current_sales - lag(current_sales) over(partition by product_name order by order_year) < 0 then 'Decrease'
    else 'No change'
end 

from yearly_product_sales
order by product_name,order_year

-- Part-To-Whole Analysis --

with tt_sales as 
(select
category,
sum(sales_amount) total_sales
from gold.fact_sales f 
left join gold.dim_products p 
on p.product_key = f.product_key
group by category)
select 
category,
total_sales,
sum(total_sales) over() overall_sales,
round(total_sales/sum(total_sales) over() * 100 , 2) || '%'
from tt_sales

-- Data Segmentation --

with product_segments as 
(select
product_key,
product_name,
cost,
case 
    when cost < 100 then 'Below 100'
    when cost between 100 and 500 then '100-500'
    when cost between 500 and 1000 then '500-1000'
    else 'Above 1000'

end  cost_range
from gold.dim_products)

select 
cost_range,
count(cost_range) as product_count

from product_segments
group by cost_range
order by count(cost_range) desc

/*Group customers into three segments based on their spending behavior:
    - VIP: Customers with at least 12 months of history and spending more than €5,000.
    - Regular: Customers with at least 12 months of history but spending €5,000 or less.
    - New: Customers with a lifespan less than 12 months.
And find the total number of customers by each group
*/

with customer_spending as 

(select 
c.customer_key,
sum(f.sales_amount) as total_spending,
min(order_date) as first_order,
max(order_date) as last_order,
extract  ( year from age(max(order_date), min(order_date))  )* 12 +
extract  ( month from age(max(order_date) , min(order_date))  )
 lifespan
from gold.fact_sales f 
left join gold.dim_customer c 
on f.customer_key = c.customer_key
group by c.customer_key)


select 
t.customer_segment,
count(t.customer_segment)

from 
(



select 
customer_key,
case
    when lifespan >= 12 and total_spending > 5000 then 'VIP'
    when lifespan >= 12 and total_spending <= 5000 then 'Regular'
    else 'New'
end customer_segment 
from customer_spending
) t
group by t.customer_segment

