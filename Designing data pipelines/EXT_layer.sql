use role ACCOUNTADMIN;
grant usage on integration PARK_INN_INTEGRATION to role DATA_ENGINEER;

-- use the DATA_ENGINEER role going forward
use role DATA_ENGINEER;
use warehouse BAKERY_WH;
use database BAKERY_DB;
use schema EXT;


-- view files in the stage
list @JSON_ORDERS_STAGE;

-- create the extract table for the orders in raw (json) format
create table JSON_ORDERS_EXT (
  customer_orders variant,
  source_file_name varchar,
  load_ts timestamp
);