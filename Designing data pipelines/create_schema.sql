use role SYSADMIN;
use database BAKERY_DB;

-- create schema with managed access using the SYSADMIN role
create schema EXT with managed access;
create schema STG with managed access;
create schema DWH with managed access;
create schema MGMT with managed access;


-- using the SECURITYADMIN role (because this role has the MANAGE GRANTS privilege)
use role SECURITYADMIN;


-- grant full privileges on all schemas to the BAKERY_FULL role
grant all on schema BAKERY_DB.EXT to role BAKERY_FULL;
grant all on schema BAKERY_DB.STG to role BAKERY_FULL;
grant all on schema BAKERY_DB.DWH to role BAKERY_FULL;
grant all on schema BAKERY_DB.MGMT to role BAKERY_FULL;
