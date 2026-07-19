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

