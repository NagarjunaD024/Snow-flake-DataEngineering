-- to keep the exercise simple, the DATA_ENGINEER role creates and applies masking policies
-- grant privileges to create and apply masking policies to the DATA_ENGINEER role
use role ACCOUNTADMIN;
grant create masking policy on schema BAKERY_DB.DG to role DATA_ENGINEER;
grant apply masking policy on account to role DATA_ENGINEER;