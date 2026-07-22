-- grant the SNOWFLAKE.CORTEX_USER to the SYSADMIN role
use role ACCOUNTADMIN;
grant database role SNOWFLAKE.CORTEX_USER to role SYSADMIN;


-- use the SYSADMIN role and the REVIEWS schema in the BAKERY_DB database
use role SYSADMIN;
use database BAKERY_DB;
use schema REVIEWS;