# /*

# NHS Emergency Department Data Analysis

This project explores NHS Emergency Department performance data using SQL.

It demonstrates:

* Creating and structuring a relational database table
* Handling missing values
* Converting data types
* Standardising fields for analysis
* Identifying and removing duplicate records
* Aggregating hospital performance metrics over time

The analysis focuses on:

* Total attendances
* Four-hour performance
* Long-wait admissions
* Yearly trends
* Hospital-level comparisons

# The cleaned dataset is prepared for reporting and further analysis.

*/


DROP TABLE IF EXISTS NHS;

CREATE TABLE NHS (
    date DATE,
    name TEXT,
    "Type 1 Departments - Major A&E" TEXT,
    "Type 2 Departments - Single Specialty" TEXT,
    "Type 3 Departments - Other A&E/Minor Injury Unit" TEXT,
    "Total attendances" NUMERIC,
    "Type 1 Departments - 4 hours to decision" NUMERIC,
    "Type 2 Departments - 4 hours to decision" NUMERIC,
    "Type 3 Departments - 4 hours to decision" NUMERIC,
    "Percentage in 4 hours or less (all)" NUMERIC,
    "Emergency Admissions via Type 1 A&E in 4 hours" NUMERIC,
    "Emergency Admissions via Type 2 A&E in 4 hours" NUMERIC,
    "Emergency Admissions via Type 3 and 4 A&E in 4 hours" NUMERIC,
    "Other Emergency admissions (i.e not via A&E)" NUMERIC,
    "Number of patients spending >12 hours from decision to admit to admission" NUMERIC,
    month TEXT,
    year TEXT,
    lat NUMERIC,
    lon NUMERIC
);

-- Initial exploratory analysis
-- Checking names have same formats
SELECT DISTINCT name FROM NHS;
SELECT DISTINCT year FROM NHS;

-- Updating year and month columns based upon date
UPDATE NHS
SET month = EXTRACT(MONTH FROM date),
    year = EXTRACT(YEAR FROM date);

-- Renaming month/year columns to be distinct from SQL syntax
ALTER TABLE NHS
RENAME COLUMN year TO year_value;

ALTER TABLE NHS
RENAME COLUMN month TO month_value;

-- Checking for null values
SELECT COUNT(*) FROM NHS;
SELECT COUNT(*) FROM NHS WHERE name IS NULL;
SELECT COUNT(*) FROM NHS WHERE "Total attendances" IS NULL;
SELECT COUNT(*) FROM NHS WHERE date IS NULL;

SELECT *
FROM NHS
WHERE name IS NULL;

-- Removing values where name is null (these rows are missing all data)
DELETE FROM NHS
WHERE name IS NULL;

-- Update month and year columns to integers instead of text
ALTER TABLE NHS
ALTER COLUMN month_value TYPE INTEGER
USING month_value::INTEGER;

ALTER TABLE NHS
ALTER COLUMN year_value TYPE INTEGER
USING year_value::INTEGER;

-- Identifying duplicate rows
SELECT date, name, COUNT(*) AS row_count
FROM NHS
GROUP BY date, name
HAVING COUNT(*) > 1;

-- Removing duplicate rows
WITH duplicates AS (
    SELECT
        ctid,
        *,
        ROW_NUMBER() OVER (
            PARTITION BY date, name
            ORDER BY ctid
        ) AS row_num
    FROM NHS
)
DELETE FROM NHS n
USING duplicates d
WHERE d.ctid = n.ctid
  AND d.row_num > 1;

-- Analysis

-- Summary
SELECT
    COUNT(*) AS total_rows,
    MIN(date) AS earliest_date,
    MAX(date) AS latest_date,
    AVG("Total attendances") AS avg_attendances,
    AVG("Percentage in 4 hours or less (all)") AS avg_4hr_pct
FROM NHS;

-- Trends by year
SELECT
    year_value,
    SUM("Total attendances") AS total_attendances,
    AVG("Total attendances") AS avg_attendances,
    AVG("Percentage in 4 hours or less (all)") AS avg_under_4hr_pct,
    AVG("Number of patients spending >12 hours from decision to admit to admission") AS avg_num_over_12h
FROM NHS
GROUP BY year_value
ORDER BY year_value;

SELECT
    year_value,
    COUNT(*) AS record_count,
    SUM("Total attendances") AS total_attendances,
    AVG("Number of patients spending >12 hours from decision to admit to admission") AS avg_num_wait_over12h,
    SUM("Number of patients spending >12 hours from decision to admit to admission") AS sum_wait_over12h,
    SUM("Number of patients spending >12 hours from decision to admit to admission") / NULLIF(SUM("Total attendances"), 0) * 100 AS perc_attendances_wait_over12h
FROM NHS
GROUP BY year_value
ORDER BY perc_attendances_wait_over12h DESC NULLS LAST;

-- Best/worst performing hospitals
SELECT
    name,
    AVG("Percentage in 4 hours or less (all)") AS avg_under_4hr_pct
FROM NHS
GROUP BY name
ORDER BY AVG("Percentage in 4 hours or less (all)") ASC;

SELECT
    name,
    AVG("Percentage in 4 hours or less (all)") AS avg_under_4hr_pct
FROM NHS
GROUP BY name
ORDER BY AVG("Percentage in 4 hours or less (all)") DESC;

SELECT
    name,
    COUNT(*) AS record_count,
    SUM("Total attendances") AS total_attendances,
    AVG("Number of patients spending >12 hours from decision to admit to admission") AS avg_num_wait_over12h,
    SUM("Number of patients spending >12 hours from decision to admit to admission") AS sum_wait_over12h,
    SUM("Number of patients spending >12 hours from decision to admit to admission") / NULLIF(SUM("Total attendances"), 0) * 100 AS perc_attendances_wait_over12h
FROM NHS
GROUP BY name
ORDER BY perc_attendances_wait_over12h DESC NULLS LAST;

-- By year and hospital
SELECT
    name,
    year_value,
    COUNT(*) AS record_count,
    SUM("Total attendances") AS total_attendances,
    AVG("Number of patients spending >12 hours from decision to admit to admission") AS avg_num_wait_over12h,
    SUM("Number of patients spending >12 hours from decision to admit to admission") AS sum_wait_over12h,
    SUM("Number of patients spending >12 hours from decision to admit to admission") / NULLIF(SUM("Total attendances"), 0) * 100 AS perc_attendances_wait_over12h
FROM NHS
GROUP BY name, year_value
ORDER BY perc_attendances_wait_over12h DESC NULLS LAST;

SELECT
    name,
    COUNT(*) AS record_count,
    SUM("Total attendances") AS total_attendances,
    AVG("Total attendances") AS avg_attendances,
    AVG("Percentage in 4 hours or less (all)") AS avg_under_4hr_pct
FROM NHS
GROUP BY name
ORDER BY avg_under_4hr_pct ASC;
