use role DATA_ENGINEER;
use warehouse BAKERY_WH;
use database BAKERY_DB;
use schema DWH;

-- create a table in the data warehouse layer and populate initially with the data from the staging layer
create table PRODUCT_TBL as select * from STG.PRODUCT;
select * from PRODUCT_TBL;


-- create a stream on the table in the staging layer
use schema STG;
create stream PRODUCT_STREAM on table PRODUCT;
