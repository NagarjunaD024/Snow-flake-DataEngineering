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


-- create a stream on the table
create stream JSON_ORDERS_STREAM 
on table JSON_ORDERS_EXT;


-- view data in the stream
select * from JSON_ORDERS_STREAM;


-- view files in the stage
list @JSON_ORDERS_STAGE;


-- copy data from the stage into the JSON_ORDERS_EXT table
copy into JSON_ORDERS_EXT
from (
  select 
    $1, 
    metadata$filename, 
    current_timestamp() 
  from @JSON_ORDERS_STAGE
)
on_error = abort_statement
;


-- check the data in the stream again
select * from JSON_ORDERS_STREAM;


-- create a staging table in the STG schema that will store the flattened semi-structured data from the extraction layer
create table STG.JSON_ORDERS_TBL_STG (
  customer varchar,
  order_date date,
  delivery_date date,
  baked_good_type varchar,
  quantity number,
  source_file_name varchar,
  load_ts timestamp
);



-- insert the flattened data from the stream into the staging table
insert into STG.JSON_ORDERS_TBL_STG
select 
  customer_orders:"Customer"::varchar as customer, 
  customer_orders:"Order date"::date as order_date, 
  CO.value:"Delivery date"::date as delivery_date,
  DO.value:"Baked good type":: varchar as baked_good_type,
  DO.value:"Quantity"::number as quantity,
  source_file_name,
  load_ts
from EXT.JSON_ORDERS_STREAM,
lateral flatten (input => customer_orders:"Orders") CO,
lateral flatten (input => CO.value:"Orders by day") DO;



-- check the data in the table:
select * from STG.JSON_ORDERS_TBL_STG;


-- check the data in the stream again
select * from JSON_ORDERS_STREAM;



-- copy data from the stage into the JSON_ORDERS_EXT table
copy into JSON_ORDERS_EXT
from (
  select 
    $1, 
    metadata$filename, 
    current_timestamp() 
  from @JSON_ORDERS_STAGE
)
on_error = abort_statement
;



-- check the data in the stream again
select * from JSON_ORDERS_STREAM;