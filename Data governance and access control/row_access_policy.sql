use role SYSADMIN;
use database BAKERY_DB;


-- create schema with managed access using the SYSADMIN role
create schema DG with managed access;
grant all on schema DG to role BAKERY_FULL;