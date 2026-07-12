-- initial setup: create database, schema and virtual warehouse
use role SYSADMIN;
create database BAKERY_DB;
create schema ORDERS;
create warehouse BAKERY_WH with warehouse_size = 'XSMALL';

-- create named internal stage
use database BAKERY_DB;
use schema ORDERS;
create stage ORDERS_STAGE;

