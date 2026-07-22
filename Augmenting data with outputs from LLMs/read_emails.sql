--python -m pip install snowflake-ml-python
use role SYSADMIN;
use database BAKERY_DB;
use schema REVIEWS;


use role ACCOUNTADMIN;
alter account set CORTEX_ENABLED_CROSS_REGION = 'ANY_REGION';

-- create a stored procedure that calls the Snowflake Cortex Complete model
-- it then converts the resulting CSV output into a data frame and saves it to a table
create or replace procedure READ_EMAIL_PROC(email_content varchar)
returns table()
language python
runtime_version = 3.10
handler = 'get_order_info_from_email'
packages = ('snowflake-snowpark-python', 'snowflake-ml-python')
AS
$$
import _snowflake
import snowflake.snowpark as snowpark
from snowflake.snowpark.types import StructType, StructField, DateType, StringType, IntegerType

def get_order_info_from_email(session: snowpark.Session, email_content):

  prompt = f"""You are a bakery employee, reading customer emails asking for deliveries. \
    Please read the email at the end of this text and extract information about the ordered items.  \
    Format the information in CSV using the following columns: customer, order_date, delivery_date, item, and quantity. \
    Format the date as YYYY-MM-DD. If no year is given, assume the current year. \
    Use the current date in the format YYYY-MM-DD for the order date.  \
    Items should be in this list: [white loaf, rye loaf, baguette, bagel, croissant, chocolate muffin, blueberry muffin].  \
    The content of the email follows this line. \n {email_content}"""

  csv_output = session.sql("SELECT SNOWFLAKE.CORTEX.COMPLETE('mistral-large2', ?)", params=[prompt]).collect()[0][0]
  
  schema = StructType([ 
        StructField("CUSTOMER", StringType(), False),  
        StructField("ORDER_DATE", DateType(), False),  
        StructField("DELIVERY_DATE", DateType(), False), 
        StructField("ITEM", StringType(), False),  
        StructField("QUANTITY", IntegerType(), False)
    ])

  orders_df = session.create_dataframe([x.split(',') for x in csv_output.split("\n")][1:], schema)
  orders_df.write.mode("append").save_as_table('COLLECTED_ORDERS_FROM_EMAIL')
    
  return orders_df
$$;


