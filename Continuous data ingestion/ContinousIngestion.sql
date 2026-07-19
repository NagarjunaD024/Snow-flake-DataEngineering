-- create a storage integration
use role ACCOUNTADMIN;


use role ACCOUNTADMIN;
create storage integration SPEEDY_INTEGRATION
  type = external_stage
  storage_provider = 'AZURE'
  enabled = true
  azure_tenant_id = '5f3419cf-49eb-4713-9edb-8a3c39a7989c'
  storage_allowed_locations = 
    ('azure://bakeryorders897764.blob.core.windows.net/speedyservicefiles8977/');
