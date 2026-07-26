use role DATA_ENGINEER;
use warehouse BAKERY_WH;
use database BAKERY_DB;
use schema DWH;

-- create views PARTNER and PRODUCT in the DWH schema that select data from the STG schema
create view PARTNER as
select partner_id, partner_name, address, rating
from STG.PARTNER;
