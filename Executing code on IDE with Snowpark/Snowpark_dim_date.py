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


# define the start date
start_dt = date(2023, 1, 1)
# define number of days
# use the value 5 to generate a sample dimension with 5 days
no_days = 5 
# change the value to 731 to generate dates for 731 days (years 2023 and 2024)
#no_days = 731
# store consecutive dates starting from the start date in a list
dates = [(start_dt + timedelta(days=i)).isoformat() for i in range(no_days)]


# create a list of lists that combines the list of dates with the output of the is_holiday() function
holiday_flags = [[d, is_holiday(d, 'US')] for d in dates]

# print the holiday_flags list of lists locally to check that the data is as expected
print(holiday_flags)