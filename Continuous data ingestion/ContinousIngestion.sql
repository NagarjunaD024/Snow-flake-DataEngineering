-- create a storage integration
use role ACCOUNTADMIN;


use role ACCOUNTADMIN;
create storage integration SPEEDY_INTEGRATION
  type = external_stage
  storage_provider = 'AZURE'
  enabled = true
  azure_tenant_id = '5f3419cf-49eb-4713-9edb-8a3c39a7989c'
  storage_allowed_locations = 
    ('azure://bakeryorders897764.blob.core.windows.net/speedyservicefiles8977/');



-- describe the storage integration and take note of the following parameters:
-- - AZURE_CONSENT_URL
-- - AZURE_MULTI_TENANT_APP_NAME
describe integration SPEEDY_INTEGRATION;

-- grant usage on storage integration so that the SYSADMIN role can use it
grant usage on integration SPEEDY_INTEGRATION to role SYSADMIN;


-- create a new schema 
use role SYSADMIN;
create warehouse if not exists BAKERY_WH with warehouse_size = 'XSMALL';
create database if not exists BAKERY_DB;
use database BAKERY_DB;
create schema DELIVERY_ORDERS;
use schema DELIVERY_ORDERS;


-- create an external stage using the storage integration
create stage SPEEDY_STAGE
  storage_integration = SPEEDY_INTEGRATION
  url = 'azure://bakeryorders897764.blob.core.windows.net/speedyservicefiles8977/'
  file_format = (type = json);


-- view files in the external stage
list @SPEEDY_STAGE;

-- view data in the staged files
select $1 from @SPEEDY_STAGE;



-- extract the ORDER_ID and ORDER_DATETIME columns from the JSON, but leave ITEMS as variant without parsing
select 
  $1:"Order id",
  $1:"Order datetime",
  $1:"Items",
  metadata$filename, 
  current_timestamp() 
from @SPEEDY_STAGE;


-- create staging table for delivery orders
create table SPEEDY_ORDERS_RAW_STG (
  order_id varchar,
  order_datetime timestamp,
  items variant,
  source_file_name varchar,
  load_ts timestamp
);



-- configure event grid messages for blob storage events
-- - enable the event grid resource provider
-- - create a storage queue and take note of the queue URL
-- - create an event grid subscription with an event grid system topic for the "Blob Created" event


-- create a notification integration
use role ACCOUNTADMIN;
CREATE NOTIFICATION INTEGRATION SPEEDY_QUEUE_INTEGRATION
ENABLED = true
TYPE = QUEUE
NOTIFICATION_PROVIDER = AZURE_STORAGE_QUEUE
AZURE_STORAGE_QUEUE_PRIMARY_URI = 'https://bakeryorders897764.queue.core.windows.net/speedyordersqueue'
AZURE_TENANT_ID = '5f3419cf-49eb-4713-9edb-8a3c39a7989c';



-- describe the storage integration and take note of the following parameters:
-- - AZURE_CONSENT_URL
-- - AZURE_MULTI_TENANT_APP_NAME
describe notification integration SPEEDY_QUEUE_INTEGRATION;

-- grant usage on notification integration so that the SYSADMIN role can use it
grant usage on integration SPEEDY_QUEUE_INTEGRATION to role SYSADMIN;



-- create the snowpipe
use role SYSADMIN;
use database BAKERY_DB;
use schema DELIVERY_ORDERS;

create pipe SPEEDY_PIPE
  auto_ingest = true
  integration = 'SPEEDY_QUEUE_INTEGRATION'
  as
  copy into SPEEDY_ORDERS_RAW_STG
  from (
    select 
      $1:"Order id",
      $1:"Order datetime",
      $1:"Items",
      metadata$filename, 
      current_timestamp() 
    from @SPEEDY_STAGE
  );



-- load historical data from files that existed in the external stage before Event Grid messages were configured
alter pipe SPEEDY_PIPE refresh;



-- view data in the staging table
select * 
from SPEEDY_ORDERS_RAW_STG;

-- check the status of the pipe
select system$pipe_status('SPEEDY_PIPE');
