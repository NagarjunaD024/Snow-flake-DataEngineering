use role SYSADMIN;
create warehouse if not exists BAKERY_WH with warehouse_size = 'XSMALL';
create database if not exists BAKERY_DB;
use database BAKERY_DB;

-- create schemas with managed access
create schema RAW with managed access;
create schema RPT with managed access;


-- using the USERADMIN role (because this role has the CREATE ROLE privilege)
use role USERADMIN;


-- create the access roles for full access and for read-only access
create role BAKERY_FULL;
create role BAKERY_READ;


-- create the functional roles
create role DATA_ENGINEER;
create role DATA_ANALYST;
