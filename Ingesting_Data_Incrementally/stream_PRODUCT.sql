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



-- make some changes in the staging table: one update and one insert
update PRODUCT
  set category = 'Pastry', valid_from = '2023-08-08'
  where product_id = 3;
  
insert into PRODUCT values
  (13, 'Sourdough Bread', 'Bread', 1, 3.6, '2023-08-08');
