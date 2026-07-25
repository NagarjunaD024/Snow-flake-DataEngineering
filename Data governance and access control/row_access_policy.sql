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