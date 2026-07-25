-- ==============================================================================
-- PURPOSE: Ranking on magnitude analysis
-- ==============================================================================
--- Ranking Analysis --

-- # Top 5 performing products

select
p.product_key,
sum(f.sales_amount) as total_revenue 
from gold.fact_sales f 
left join gold.dim_products p 
on p.product_key = f.product_key
group by 
p.product_key
order by sum(f.sales_amount) desc
limit 5

-- # Worst 5 performing products


select
p.product_key,
sum(f.sales_amount) as total_revenue 
from gold.fact_sales f 
left join gold.dim_products p 
on p.product_key = f.product_key
group by 
p.product_key
order by sum(f.sales_amount) 
limit 5



select
p.product_name,
sum(f.sales_amount) as total_revenue,
row_number() over(order by sum(f.sales_amount)) 
from gold.fact_sales f 
left join gold.dim_products p 
on p.product_key = f.product_key
group by 
p.product_name
order by sum(f.sales_amount) 
limit 5
