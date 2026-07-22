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


-- Create UDF GET_MOVIE_REVIEWS
use role SYSADMIN;
create or replace function GET_MOVIE_REVIEWS(movie_id varchar)
returns variant
language python
runtime_version = 3.10
handler = 'get_reviews'
external_access_integrations = (TMDB_API_INTEGRATION)
secrets = ('tmdb_api_token' = TMDB_API_TOKEN)
packages = ('requests')
as
$$
import _snowflake
import requests
def get_reviews(movie_id):
    api_token = _snowflake.get_generic_secret_string('tmdb_api_token')
    url = f'https://api.themoviedb.org/3/movie/{movie_id}/reviews'
    response = requests.get(
        url=url,
        headers={'Authorization': 'Bearer ' + api_token, 'accept': 'application/json'}
    )
    return response.json()
$$;


-- select from the UDF
select
    value:author::varchar                       as author,
    value:author_details.rating::number         as rating,
    value:created_at::timestamp                 as time_created,
    value:content::varchar                      as customer_review
from table(flatten(
    input => GET_MOVIE_REVIEWS('687163'):results     
));

-- create a table to store the customer reviews
use schema REVIEWS;
create table CUSTOMER_REVIEWS (
  rating number,
  time_created timestamp,
  customer_review varchar
);
