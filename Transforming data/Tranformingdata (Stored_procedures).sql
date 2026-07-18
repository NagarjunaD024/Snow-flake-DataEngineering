use role SYSADMIN;
create warehouse if not exists BAKERY_WH with warehouse_size = 'XSMALL';
use warehouse BAKERY_WH;
create database if not exists BAKERY_DB;
use database BAKERY_DB;
create schema TRANSFORM;
use schema TRANSFORM;



-- create a view that combines data from individual staging tables
create view ORDERS_COMBINED_STG as
select customer, order_date, delivery_date, baked_good_type, quantity, source_file_name, load_ts
from bakery_db.orders.ORDERS_STG
union all
select customer, order_date, delivery_date, baked_good_type, quantity, source_file_name, load_ts
from bakery_db.external_orders.ORDERS_BISTRO_STG
union all
select customer, order_date, delivery_date, baked_good_type, quantity, source_file_name, load_ts
from bakery_db.external_json_orders.ORDERS_PARK_INN_STG;




