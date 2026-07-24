-- use the RETAIL_ANALYSIS schema in the BAKERY_DB database 
use role SYSADMIN;
use database BAKERY_DB;
use schema RETAIL_ANALYSIS;



-- create a set of virtual warehouses in increasing sizes
create warehouse BAKERY_WH_XSMALL with warehouse_size = 'xsmall';
create warehouse BAKERY_WH_SMALL with warehouse_size = 'small';
create warehouse BAKERY_WH_MEDIUM with warehouse_size = 'medium';
create warehouse BAKERY_WH_LARGE with warehouse_size = 'large';


