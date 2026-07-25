use role SYSADMIN;
create warehouse if not exists BAKERY_WH with warehouse_size = 'XSMALL';
create database if not exists BAKERY_DB;
use database BAKERY_DB;

-- create schemas with managed access
create schema RAW with managed access;
create schema RPT with managed access;


-- using the USERADMIN role (because this role has the CREATE ROLE privilege)
use role USERADMIN;