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


-- view the contents of the stage again (should be empty again because the file was purged after loading)
list @ORDERS_STAGE;

-- create the target table
use database BAKERY_DB;
use schema ORDERS;
create or replace table CUSTOMER_ORDERS (
  customer varchar,
  order_date date,
  delivery_date date,
  baked_good_type varchar,
  quantity number,
  source_file_name varchar,
  load_ts timestamp
);


-- merge data from the staging table into the target table
-- Listing 2.2  
-- the target table
merge into CUSTOMER_ORDERS tgt
-- the source table
using ORDERS_STG as src 
-- the columns that ensure uniqueness
on src.customer = tgt.customer 
  and src.delivery_date = tgt.delivery_date 
  and src.baked_good_type = tgt.baked_good_type
-- update the target table with the values from the source table
when matched then 
  update set tgt.quantity = src.quantity, 
    tgt.source_file_name = src.source_file_name, 
    tgt.load_ts = current_timestamp()
-- insert new values from the source table into the target table
when not matched then
  insert (customer, order_date, delivery_date, baked_good_type, 
    quantity, source_file_name, load_ts)
  values(src.customer, src.order_date, src.delivery_date, 
    src.baked_good_type, src.quantity, src.source_file_name,
    current_timestamp());


-- view data after merging
select * from CUSTOMER_ORDERS order by delivery_date desc;

