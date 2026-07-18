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


use role SYSADMIN;
-- set the log level on the stored procedure to DEBUG
alter procedure LOAD_CUSTOMER_ORDERS() set log_level = DEBUG;


-- modify the stored procedure: add logging
use database BAKERY_DB;
use schema TRANSFORM;
create or replace procedure LOAD_CUSTOMER_ORDERS()
returns varchar
language sql
as
$$
begin
  SYSTEM$LOG_DEBUG('LOAD_CUSTOMER_ORDERS begin ');
  merge into CUSTOMER_ORDERS_COMBINED tgt
using ORDERS_COMBINED_STG as src
on src.customer = tgt.customer and src.delivery_date = tgt.delivery_date and src.baked_good_type = tgt.baked_good_type
when matched then 
  update set tgt.quantity = src.quantity, 
    tgt.source_file_name = src.source_file_name, 
    tgt.load_ts = current_timestamp()
when not matched then
  insert (customer, order_date, delivery_date, 
    baked_good_type, quantity, source_file_name, load_ts)
  values(src.customer, src.order_date, src.delivery_date,
    src.baked_good_type, src.quantity, src.source_file_name,
    current_timestamp());
  return 'Load completed. ' || SQLROWCOUNT || ' rows affected.';
exception
  when other then
    return 'Load failed with error message: ' || SQLERRM;
end;
$$
;


-- execute the stored procedure
call LOAD_CUSTOMER_ORDERS();


-- after waiting a few minutes, select data from the event table
select * 
from bakery_events 
order by timestamp desc;