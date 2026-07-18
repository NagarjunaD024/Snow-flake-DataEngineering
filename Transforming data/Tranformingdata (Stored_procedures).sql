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



-- create target table that will store historical orders combined from all sources
use database BAKERY_DB;
use schema TRANSFORM;
use schema TRANSFORM;
create or replace table CUSTOMER_ORDERS_COMBINED (
  customer varchar,
  order_date date,
  delivery_date date,
  baked_good_type varchar,
  quantity number,
  source_file_name varchar,
  load_ts timestamp
);



