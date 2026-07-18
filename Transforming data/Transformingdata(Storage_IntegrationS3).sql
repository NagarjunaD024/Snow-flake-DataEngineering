-- create a storage integration
-- using Amazon S3
-- refer to Chapter 3 for Microsoft Azure
use role ACCOUNTADMIN;

create storage integration PARK_INN_INTEGRATION
  type = external_stage
  storage_provider = 'S3'
  enabled = true
  storage_aws_role_arn = 'arn:aws:iam::123456789012:role/Snowflake-demo'
  storage_allowed_locations = ('s3://parkinnorders8977/');

  -- describe the storage integration and take note of the following parameters:
-- - STORAGE_AWS_IAM_USER_ARN
-- - STORAGE_AWS_EXTERNAL_ID
describe storage integration PARK_INN_INTEGRATION;

-- grant usage on storage integration so that the SYSADMIN role can use it
grant usage on integration PARK_INN_INTEGRATION to role SYSADMIN;


-- create a new schema in the BAKERY_DB database for json Ingestion
use role SYSADMIN;
create warehouse if not exists BAKERY_WH with warehouse_size = 'XSMALL';
use warehouse BAKERY_WH;
create database if not exists BAKERY_DB;
use database BAKERY_DB;
create schema EXTERNAL_JSON_ORDERS;
use schema EXTERNAL_JSON_ORDERS;

-- create an external stage using the storage integration
create stage PARK_INN_STAGE
  storage_integration = PARK_INN_INTEGRATION
  url = 's3://parkinnorders8977/'
  file_format = (type = json);


  -- view files in the external stage
list @PARK_INN_STAGE;

-- view data in the staged file
select $1 from @PARK_INN_STAGE;


-- create staging table for restaurant orders in raw (json) format
use database BAKERY_DB;
use schema EXTERNAL_JSON_ORDERS;
create table ORDERS_PARK_INN_RAW_STG (
  customer_orders variant,
  source_file_name varchar,
  load_ts timestamp
);

