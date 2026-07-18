use warehouse BAKERY_WH;
use database BAKERY_DB;
use schema TRANSFORM;

use role SYSADMIN;
-- create an event table
create event table BAKERY_EVENTS;


use role ACCOUNTADMIN;
-- associate the event table with the account
alter account set event_table = BAKERY_DB.TRANSFORM.BAKERY_EVENTS;
-- grant privileges to set log level to the SYSADMIN role
grant modify log level on account to role SYSADMIN;