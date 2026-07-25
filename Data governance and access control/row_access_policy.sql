use role SYSADMIN;
use database BAKERY_DB;


-- create schema with managed access using the SYSADMIN role
create schema DG with managed access;
grant all on schema DG to role BAKERY_FULL;


use role USERADMIN;
-- create the functional roles
create role DATA_ANALYST_BREAD;
create role DATA_ANALYST_PASTRY;


-- grant the BAKERY_READ access role to functional roles
grant role BAKERY_READ to role DATA_ANALYST_BREAD;
grant role BAKERY_READ to role DATA_ANALYST_PASTRY;


-- grant the functional roles to the users who perform those business functions
-- in this exercise we grant both functional roles to our current user to be able to test them

set my_current_user = current_user();
grant role DATA_ANALYST_BREAD to user IDENTIFIER($my_current_user);
grant role DATA_ANALYST_PASTRY to user IDENTIFIER($my_current_user);



-- grant usage on the BAKERY_WH warehouse to the functional roles
use role SYSADMIN;
grant usage on warehouse BAKERY_WH to role DATA_ANALYST_BREAD;
grant usage on warehouse BAKERY_WH to role DATA_ANALYST_PASTRY;