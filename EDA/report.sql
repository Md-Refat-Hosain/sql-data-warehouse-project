-- ==============================================================================
-- PURPOSE:  Report generation 
-- ==============================================================================

-- Generate a Report that shows all key metrics of the business

select 'Total Sales' as measure_name , sum(sales_amount) as measure_value 
from gold.fact_sales

union all 

select 'Total Quantity' as measure_name , sum(quantity) as measure_value 
from gold.fact_sales

union all 

select 'Average Price' , round(avg(price)) from gold.fact_sales

union all 

select 'Total Nr. Orders' , count(distinct order_number) from gold.fact_sales

union all 

select 'Total Nr. Products', count(product_name) from gold.dim_products

union all 

select 'Total Nr. Customers', count(customer_key) from gold.dim_customer
