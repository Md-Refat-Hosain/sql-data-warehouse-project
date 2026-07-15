
/*
================================================================================
DDL Script: Create gold facts & dimensions
================================================================================
Script Purpose:
    This is a simple script, Here I created fact & dimension as 'view' simply from 'silver' layer. No new table been created here.
================================================================================
*/

--##--All Tables



CREATE view gold.dim_customer as

select 
row_number() over (order by cst_id ) as customer_key,
ci.cst_id customer_id,
ci.cst_key customer_number ,
ci.cst_first_name first_name ,
ci.cst_last_name last_name,
case 
    when ci.cst_gndr != 'n/a' then ci.cst_gndr
    else ca.gen
end gender,
ci.cst_marital_status marital_status,
la.cntry country,
ca.bdate birth_date,


ci.cst_create_date create_date
-- from ca


from silver.crm_cust_info ci 
left join
silver.erp_cust_az12 ca
on ci.cst_key = ca.cid
left join silver.erp_loc_a101 la
on ci.cst_key = la.cid
-----------------------

select distinct gender from gold.dim_customer

----- 2nd dimention-----


create view gold.dim_products as
select 

row_number() over(order by pi.prd_start_dt,pi.prd_key) as product_key,

pi.prd_id product_id,
pi.prd_key product_number,
pi.prd_nm product_name,
pc.cat category,
pc.subcat sub_category,
pi.cat_id category_id,
pi.prd_line product_line,
pi.prd_cost cost,
pc.maintanace,
pi.prd_start_dt start_date




from silver.crm_prd_info pi
inner join silver.erp_px_cat_g1v2  pc
on pi.cat_id = pc.id
where pi.prd_end_dt is null


select * from silver.crm_prd_info pi

select * from silver.erp_px_cat_g1v2  pc


---------------- 3rd dimention -------------------

create view gold.fact_sales as 
select 
sd.sls_ord_num order_number,
dp.product_key ,
dc.customer_key,
sd.sls_order_dt order_date,
sd.sls_ship_dt shipping_date,
sd.sls_due_dt due_date,
sd.sls_sales sales_amount,
sd.sls_price price,
sd.sls_qty quantity

from silver.crm_sales_details sd
left join gold.dim_customer dc
on sd.sls_cust_id = dc.customer_id
left join gold.dim_products dp
on sd.sls_prd_key = dp.product_number


select * from gold.dim_products
select * from gold.dim_customer
