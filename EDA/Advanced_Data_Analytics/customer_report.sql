
-- Report -- 
/*
===============================================================================
Customer Report
===============================================================================
Purpose:
    - This report consolidates key customer metrics and behaviors

Highlights:
    1. Gathers essential fields such as names, ages, and transaction details.
    2. Segments customers into categories (VIP, Regular, New) and age groups.
    3. Aggregates customer-level metrics:
        - total orders
        - total sales
        - total quantity purchased
        - total products
        - lifespan (in months)
    4. Calculates valuable KPIs:
        - recency (months since last order)
        - average order value
        - average monthly spend
===============================================================================
*/
create view gold.report_customers as

with base_query as 

(select
f.order_number,
f.product_key,
f.order_date,
f.sales_amount,
f.quantity,
c.customer_key,
c.customer_number,
c.first_name,
c.last_name,
concat(c.first_name, ' ', c.last_name) customer_name,
c.birth_date,
 extract( year from age(current_date,c.birth_date  )) age
from gold.fact_sales f 
left join gold.dim_customer c 
on c.customer_key = f.customer_key
where order_date is not null)

, customer_agg as (

select
customer_key,
customer_number,
customer_name,
age,
count(distinct order_number ) as total_orders,
sum(sales_amount) total_sales,
sum(quantity) total_quantity,
count(distinct product_key) total_products,
max(order_date) last_order_date,
extract( year from age(max(order_date) , min(order_date))) * 12
+ 
extract( month from age(max(order_date) , min(order_date))) lifespan
from base_query
group by 
    customer_key,
    customer_number,
    customer_name,
    age
)    

select 
customer_key,
customer_number,
customer_name,
age,
case 
    when age < 20  then 'Under 20' 
    when age between 20 and 29 then '20-29'
    when age between 30 and 39 then '30-39'
    when age between 40 and 49 then '40-49'
    else '50 or Above'

end age_segment,

case
    when lifespan >= 12 and total_sales > 5000 then 'VIP'
    when lifespan >= 12 and total_sales <= 5000 then 'Regular'
    else 'New'
end customer_segment,
total_orders,
total_sales,
total_quantity,
total_products,
last_order_date,
extract( year from age(current_date,last_order_date )) * 12
+ 
extract( month from age(current_date ,last_order_date )) recency,
lifespan,
-- Compute average order value (AVO)
case 
     when total_orders = 0 then 0

     else round(total_sales / total_orders) 
end avg_order_value,

-- compute average monthly spend
case 
    when lifespan = 0 then total_sales
    else round(total_sales / lifespan)
end avg_monthly_spend

from 
customer_agg


select * from gold.report_customers

