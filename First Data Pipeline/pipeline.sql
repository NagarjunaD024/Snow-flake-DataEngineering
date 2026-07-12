-- initial setup: create database, schema and virtual warehouse
use role SYSADMIN;
create database BAKERY_DB;
create schema ORDERS;
create warehouse BAKERY_WH with warehouse_size = 'XSMALL';

-- create named internal stage
use database BAKERY_DB;
use schema ORDERS;
create stage ORDERS_STAGE;

-- create staging table
use database BAKERY_DB;
use schema ORDERS;
create table ORDERS_STG (
  customer varchar,
  order_date date,
  delivery_date date,
  baked_good_type varchar,
  quantity number,
  source_file_name varchar,
  load_ts timestamp
);

-- copy data from the internal stage to the staging table using parameters:
-- - file_format to specify that the header line is to be skipped
-- - on_error to specify that the statement is to be aborted if an error is encountered
-- - purge the csv file from the internal stage after loading data
-- Listing 2.1 
use database BAKERY_DB;
use schema ORDERS;
copy into ORDERS_STG
from (
  select $1, $2, $3, $4, $5, metadata$filename, current_timestamp() 
  from @ORDERS_STAGE
)
file_format = (type = csv, skip_header = 1)
on_error = abort_statement
purge = true;

-- view the data that was loaded
select * from ORDERS_STG;

