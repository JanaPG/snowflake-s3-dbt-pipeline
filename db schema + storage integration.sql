-- AWS S3 + Snowflake + dbt integration setup
-- Co-authored with CoCo

-- Setup
CREATE DATABASE sales_db;
CREATE SCHEMA sales_db.raw;
CREATE SCHEMA sales_db.analytics;
CREATE WAREHOUSE mini_wh WITH WAREHOUSE_SIZE = 'XSMALL';

-- Storage integration (links Snowflake to your S3)
CREATE STORAGE INTEGRATION s3_integration
    TYPE = EXTERNAL_STAGE
    STORAGE_PROVIDER = S3
    STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::979627728009:role/snowflake-s3-role'
    ENABLED = TRUE
    STORAGE_ALLOWED_LOCATIONS = ('s3://aws-first-bucket-979627728009-us-east-1-an/Documents/');

-- Check the integration — copy the IAM role ARN shown
DESC INTEGRATION s3_integration;


SELECT CURRENT_ACCOUNT();