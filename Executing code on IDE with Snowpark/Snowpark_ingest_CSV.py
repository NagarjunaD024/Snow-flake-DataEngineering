# import Session from the snowflake.snowpark package
from snowflake.snowpark import Session
# import data types from the snowflake.snowpark package
from snowflake.snowpark.types import StructType, StructField, DateType, StringType, DecimalType
# import json package for reading connection parameters
import json


source_file_name = 'Orders_2023-07-09.csv'


# establish a connection with Snowflake

#Refer to Listing 6.4
# read the credentials from a file
credentials = json.load(open('connection_parameters.json'))
# create a dictionary with the connection parameters
connection_parameters_dict = {
    "account": credentials["account"],
    "user": credentials["user"],
    "password": credentials["password"],
    "role": credentials["role"],
    "warehouse": credentials["warehouse"],
    "database": credentials["database"],
    "schema": credentials["schema"]  # optional
}  

# create a session object for the Snowpark session
my_session = Session.builder.configs(connection_parameters_dict).create()


# put the file into the stage
result = my_session.file.put(source_file_name, "@orders_stage")
print(result)






