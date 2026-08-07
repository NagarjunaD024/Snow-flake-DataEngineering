use role DATA_ENGINEER;
use warehouse BAKERY_WH;
use database BAKERY_DB;
use schema DWH;

-- create a table in the data warehouse layer and populate initially with the data from the staging layer
create table PARTNER_TBL as select * from STG.PARTNER;
select * from PARTNER_TBL;
