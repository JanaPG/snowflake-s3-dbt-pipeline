use database sales_db

use schema sales_db.raw

use warehouse mini_wh

create or replace file format csv_file_format
type='csv'
field_delimiter=','
skip_header=1
field_optionally_enclosed_by='"'
null_if = ('','Null')

create or replace stage s3_stage
storage_integration=s3_integration
url='s3://aws-first-bucket-979627728009-us-east-1-an/Documents/'
file_format=csv_file_format

list @s3_stage



-- Adjust columns to match your actual CSV headers/types
CREATE OR REPLACE TABLE raw.sales_raw (
  id      number,
  name   STRING,
  age    number,
  address       STRING,
  city      string,
  state    string,
  email        string
);

COPY INTO raw.sales_raw
FROM @s3_stage
FILE_FORMAT = (FORMAT_NAME = csv_file_format)
files=('customers.csv')
ON_ERROR = 'CONTINUE'
force=true;

SELECT * FROM raw.sales_raw LIMIT 20;

SELECT *
FROM TABLE(INFORMATION_SCHEMA.COPY_HISTORY(
    TABLE_NAME => 'RAW.SALES_RAW',
    START_TIME => DATEADD('hours', -1, CURRENT_TIMESTAMP())
));