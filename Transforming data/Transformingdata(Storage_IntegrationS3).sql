-- create a storage integration
-- using Amazon S3
-- refer to Chapter 3 for Microsoft Azure
use role ACCOUNTADMIN;

create storage integration PARK_INN_INTEGRATION
  type = external_stage
  storage_provider = 'S3'
  enabled = true
  storage_aws_role_arn = 'arn:aws:iam::123456789012:role/Snowflake-demo'
  storage_allowed_locations = ('s3://parkinnorders8977/');

  -- describe the storage integration and take note of the following parameters:
-- - STORAGE_AWS_IAM_USER_ARN
-- - STORAGE_AWS_EXTERNAL_ID
describe storage integration PARK_INN_INTEGRATION;

-- grant usage on storage integration so that the SYSADMIN role can use it
grant usage on integration PARK_INN_INTEGRATION to role SYSADMIN;