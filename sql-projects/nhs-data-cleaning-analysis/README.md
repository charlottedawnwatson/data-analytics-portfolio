# NHS Emergency Department Data Analysis

## Project Overview

This project explores NHS Emergency Department performance data using SQL. It focuses on cleaning, structuring, and analysing attendance and waiting-time records across hospitals and years.

The project covers data preparation, duplicate removal, missing value handling, type conversion, and hospital-level performance analysis using aggregate queries and window functions.

## Dataset

This project uses NHS Emergency Department data with fields including:

* date
* hospital name
* total attendances
* four-hour performance measures
* patients waiting more than 12 hours from decision to admit to admission
* year and month fields
* location data

## Data Cleaning Tasks

* Checked for missing and inconsistent values
* Removed rows where hospital name was missing
* Created year and month values from the date column
* Renamed year and month fields to avoid SQL keyword conflicts
* Converted month and year fields from text to integers
* Identified and removed duplicate rows using `ROW_NUMBER()`
* Kept the dataset ready for analysis

## Analysis Performed

### Summary Analysis

* Total number of rows
* Earliest and latest dates
* Average total attendances
* Average percentage seen within four hours

### Yearly Trends

* Total attendances by year
* Average attendances by year
* Average four-hour performance by year
* Average and total long-wait admissions by year
* Percentage of attendances waiting more than 12 hours

### Hospital Performance

* Best and worst performing hospitals by average four-hour performance
* Hospitals with the highest and lowest long-wait admission percentages
* Hospital performance broken down by year

## SQL Techniques Used

* `CREATE TABLE`
* `UPDATE`
* `ALTER TABLE`
* `DELETE`
* `GROUP BY`
* `AVG()`
* `SUM()`
* `MIN()`
* `MAX()`
* `ROW_NUMBER() OVER (...)`
* `NULLIF`
* Aggregation and filtering

## Skills Demonstrated

* PostgreSQL
* Data cleaning
* Data transformation
* Data quality checks
* Duplicate removal
* Aggregation and reporting
* Window functions
* Exploratory data analysis with SQL

## Outcome

The final dataset is cleaned and prepared for analysis of NHS Emergency Department performance over time and across hospitals.

## Notes

This project is designed to show practical SQL cleaning and analysis skills using a real-world healthcare dataset.
