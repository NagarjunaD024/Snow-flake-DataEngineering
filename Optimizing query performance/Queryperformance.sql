use role ACCOUNTADMIN;
-- Get the “Sample Harmonized Data for Top CPG Retailers and Distributors” listing from the Snowflake Marketplace
-- Save the listing into a database named AI_BLUEPRINT_FOR_CPG__ONSHELF_AVAILABILITY

-- grant usage on the database to the SYSADMIN role if you haven't granted it already when getting the data
grant imported privileges on database AI_BLUEPRINT_FOR_CPG__ONSHELF_AVAILABILITY to role SYSADMIN;