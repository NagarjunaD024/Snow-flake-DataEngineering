-- create a storage integration
-- using Microsoft Azure
-- refer to Chapter 4 for Amazon S3
use role ACCOUNTADMIN;

create storage integration BISTRO_INTEGRATION
  type = external_stage
  storage_provider = 'AZURE'
  enabled = true
  azure_tenant_id = '1234abcd-xxx-56efgh78' --use your own Tenant ID
  storage_allowed_locations = ('azure://bakeryorders897764.blob.core.windows.net/order_files/');

  -- describe the storage integration and take note of the following parameters:
-- - AZURE_CONSENT_URL
-- - AZURE_MULTI_TENANT_APP_NAME
describe storage integration BISTRO_INTEGRATION;

-- grant usage on storage integration so that the SYSADMIN role can use it
grant usage on integration BISTRO_INTEGRATION to role SYSADMIN;

-- create a new schema in the BAKERY_DB database (see Chapter 2)
use role SYSADMIN;
create warehouse if not exists BAKERY_WH with warehouse_size = 'XSMALL';
create database if not exists BAKERY_DB;
use database BAKERY_DB;
create schema EXTERNAL_ORDERS;
use schema EXTERNAL_ORDERS;