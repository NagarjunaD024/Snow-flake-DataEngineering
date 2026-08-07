use role DATA_ENGINEER;
use warehouse BAKERY_WH;
use database BAKERY_DB;
use schema EXT;


-- recreate the table to remove any data from previous exercises
create or replace table JSON_ORDERS_EXT (
  customer_orders variant,
  source_file_name varchar,
  load_ts timestamp
);