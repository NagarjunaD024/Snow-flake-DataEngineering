#Listing 6.5
# import Session from the snowflake.snowpark package
from snowflake.snowpark import Session
# import data types from the snowflake.snowpark package
from snowflake.snowpark.types import StructType, StructField, DateType, BooleanType
# import json package for reading connection parameters
import json
# import date and timedelta from the datetime package for generating dates
from datetime import date, timedelta
# install the holidays package using pip or conda
# import the holidays package to determine whether a given date is a holiday
import holidays

# define a function that returns True if p_date is a holiday in p_country
def is_holiday(p_date, p_country):
    # get a list of all holidays in p_country
    all_holidays = holidays.country_holidays(p_country)
    # return True if p_date is a holiday, otherwise return false
    if p_date in all_holidays:
        return True
    else:
        return False