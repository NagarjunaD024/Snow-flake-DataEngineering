use role SYSADMIN;
create warehouse if not exists BAKERY_WH with warehouse_size = 'XSMALL';
create database if not exists BAKERY_DB;
use database BAKERY_DB;

-- create schemas with managed access
create schema RAW with managed access;
create schema RPT with managed access;


-- using the USERADMIN role (because this role has the CREATE ROLE privilege)
use role USERADMIN;


-- create the access roles for full access and for read-only access
create role BAKERY_FULL;
create role BAKERY_READ;


-- create the functional roles
create role DATA_ENGINEER;
create role DATA_ANALYST;


-- using the SECURITYADMIN role (because this role has the MANAGE GRANTS privilege)
use role SECURITYADMIN;


-- grant privileges to each of the access roles

-- grant full privileges on database BAKERY_DB to the BAKERY_FULL role
grant usage on database BAKERY_DB to role BAKERY_FULL;
grant usage on all schemas in database BAKERY_DB to role BAKERY_FULL;
grant all on schema BAKERY_DB.RAW to role BAKERY_FULL;
grant all on schema BAKERY_DB.RPT to role BAKERY_FULL;


-- grant read-only privileges on database BAKERY_DB to the BAKERY_READ role
grant usage on database BAKERY_DB to role BAKERY_READ;
grant usage on all schemas in database BAKERY_DB to role BAKERY_READ;
grant select on all tables in schema BAKERY_DB.RPT to role BAKERY_READ;
grant select on all views in schema BAKERY_DB.RPT to role BAKERY_READ;


-- grant future privileges
grant select on future tables in schema BAKERY_DB.RPT to role BAKERY_READ;
grant select on future views in schema BAKERY_DB.RPT to role BAKERY_READ;


-- grant access roles to functional roles
-- grant the BAKERY_FULL role to the DATA_ENGINEER role
grant role BAKERY_FULL to role DATA_ENGINEER;
-- grant the BAKERY_READ role to the DATA_ANALYST role
grant role BAKERY_READ to role DATA_ANALYST;


-- grant both functional roles to the SYSADMIN role
grant role DATA_ENGINEER to role SYSADMIN;
grant role DATA_ANALYST to role SYSADMIN;



