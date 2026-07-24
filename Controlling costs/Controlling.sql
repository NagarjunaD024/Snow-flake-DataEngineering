-- use the RETAIL_ANALYSIS schema in the BAKERY_DB database 
use role SYSADMIN;
use database BAKERY_DB;
use schema RETAIL_ANALYSIS;



-- create a set of virtual warehouses in increasing sizes
create warehouse BAKERY_WH_XSMALL with warehouse_size = 'xsmall';
create warehouse BAKERY_WH_SMALL with warehouse_size = 'small';
create warehouse BAKERY_WH_MEDIUM with warehouse_size = 'medium';
create warehouse BAKERY_WH_LARGE with warehouse_size = 'large';



-- construct a complex query that 
-- - selects the total sold quantity of each product in each store
-- - adds a condition to include only stores which sell more than 100 distinct products
-- - sorts the results by the distance
select 
  store_id, 
  distance_km, 
  product_id, 
  sum(sales_quantity) as total_quantity
from RETAILER_SALES
where store_id in (
  select store_id 
  from (
    select store_id, 
      count(distinct product_id) as product_cnt
    from RETAILER_SALES
    group by store_id
    having product_cnt > 100
  )
)
group by store_id, distance_km, product_id
order by distance_km;


-- use the extra small warehouse
use warehouse BAKERY_WH_XSMALL;


-- set the session so that it doesn't reuse query results - for testing only
alter session set use_cached_result = FALSE;



-- add filter to the previous query to select only stores that within 1000 km

select 
  store_id, 
  distance_km, 
  product_id, 
  sum(sales_quantity) as total_quantity
from RETAILER_SALES
where store_id in (
  select store_id 
  from (
    select store_id, 
      count(distinct product_id) as product_cnt
    from RETAILER_SALES
    where distance_km < 1000
    group by store_id
    having product_cnt > 100
  )
)
group by store_id, distance_km, product_id
order by distance_km;


-- set the session parameter to its original value that allows reusing query results
alter session set use_cached_result = TRUE;


select count(*) from RETAILER_SALES;
-- open the query profile after executing


-- change the AUTO_SUSPEND parameter to 5 minutes (300 seconds)
alter warehouse BAKERY_WH_XSMALL set AUTO_SUSPEND = 300;



-- grant the USAGE_VIEWER database role to SYSADMIN
use role ACCOUNTADMIN;
grant database role SNOWFLAKE.USAGE_VIEWER to role SYSADMIN;
use role SYSADMIN;


-- summarize the queuing time and the total execution time by each warehouse by day for the past 7 days 
select 
  to_date(start_time) as start_date, 
  warehouse_name, 
  sum(avg_running) as total_running, 
  sum(avg_queued_load) as total_queued
from SNOWFLAKE.ACCOUNT_USAGE.WAREHOUSE_LOAD_HISTORY
where TO_DATE(start_time) > DATEADD(day,-7,TO_DATE(CURRENT_TIMESTAMP()))
group by all
order by 1, 2;




-- limit the number of concurrently running queries to 6
alter warehouse BAKERY_WH_LARGE set MAX_CONCURRENCY_LEVEL = 6;