use role DATA_ENGINEER;
use warehouse BAKERY_WH;
use database BAKERY_DB;
use schema DWH;

-- create a table in the data warehouse layer and populate initially with the data from the staging layer
create table PARTNER_TBL as select * from STG.PARTNER;
select * from PARTNER_TBL;


-- create a stream on the table in the staging layer
use schema STG;
create stream PARTNER_STREAM on table PARTNER;


-- make some changes in the staging table: one update
update PARTNER
  set rating = 'A', valid_from = '2023-08-08'
  where partner_id = 103;

