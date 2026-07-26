use role ACCOUNTADMIN;
grant usage on integration PARK_INN_INTEGRATION to role DATA_ENGINEER;

-- use the DATA_ENGINEER role going forward
use role DATA_ENGINEER;
use warehouse BAKERY_WH;
use database BAKERY_DB;
use schema EXT;