-- create a new schema in the BAKERY_DB database
use role SYSADMIN;
create warehouse if not exists BAKERY_WH with warehouse_size = 'XSMALL';
create database if not exists BAKERY_DB;
use database BAKERY_DB;
create schema REVIEWS;
use schema REVIEWS;