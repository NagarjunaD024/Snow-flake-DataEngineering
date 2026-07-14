-- create a storage integration
-- using Microsoft Azure
-- refer to Chapter 4 for Amazon S3
use role ACCOUNTADMIN;

create storage integration BISTRO_INTEGRATION
  type = external_stage
  storage_provider = 'AZURE'
  enabled = true
  azure_tenant_id = '1234abcd-xxx-56efgh78' --use your own Tenant ID
  storage_allowed_locations = ('azure://bakeryorders001.blob.core.windows.net/orderfiles/');