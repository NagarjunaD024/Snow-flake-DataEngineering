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