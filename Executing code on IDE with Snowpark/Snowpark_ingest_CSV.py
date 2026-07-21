# import Session from the snowflake.snowpark package
from snowflake.snowpark import Session
# import data types from the snowflake.snowpark package
from snowflake.snowpark.types import StructType, StructField, DateType, StringType, DecimalType
# import json package for reading connection parameters
import json


source_file_name = 'Orders_2023-07-09.csv'


