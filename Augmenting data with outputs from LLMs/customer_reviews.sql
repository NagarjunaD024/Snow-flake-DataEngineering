-- create a new schema in the BAKERY_DB database
use role SYSADMIN;
create warehouse if not exists BAKERY_WH with warehouse_size = 'XSMALL';
create database if not exists BAKERY_DB;
use database BAKERY_DB;
create schema REVIEWS;
use schema REVIEWS;


-- use role ACCOUNTADMIN to grant privilege
use role ACCOUNTADMIN;
-- grant CREATE_NETWORK RULE, CREATE SECRET, and CREATE INTEGRATION privileges to role SYSADMIN
grant create network rule on schema REVIEWS to role SYSADMIN;
grant create secret on schema REVIEWS to role SYSADMIN;
grant create integration on account to role SYSADMIN;
-- switch back to the SYSADMIN role
use role SYSADMIN;

-- create a network rule
create network rule TMDB_API_NETWORK_RULE
  mode = EGRESS
  type = HOST_PORT
  value_list = ('api.themoviedb.org');

-- create a secret
create secret TMDB_API_TOKEN
type = GENERIC_STRING
secret_string = 'eyJhbGciOiJ..TVBMk';


-- grant usage on the secret to a custom role if that role will be using the secret 
grant read on secret TMDB_API_TOKEN to role <custom_role>;


create external access integration TMDB_API_INTEGRATION
  allowed_network_rules = (TMDB_API_NETWORK_RULE)
  allowed_authentication_secrets = (TMDB_API_TOKEN)
  enabled = TRUE;





