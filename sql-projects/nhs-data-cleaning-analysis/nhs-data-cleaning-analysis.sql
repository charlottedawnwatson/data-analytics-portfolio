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



-- INITIAL EXPLORATORY ANALYSIS--
--CHECKING NAMES HAVE SAME FORMATS
SELECT DISTINCT name FROM NHS;
SELECT DISTINCT year FROM NHS;

SELECT COUNT(DISTINCT name) FROM NHS;

--IDENTIFYING NAME ERRORS---
SELECT name, COUNT(name) as name_counts FROM NHS
GROUP BY name
ORDER BY name DESC;


--CORRECTING MISSPELLS AND STANDARDISING NAMES--

UPDATE NHS
SET name = REPLACE(
	INITCAP(LOWER(name)),
	'Nhs',
	'NHS');

UPDATE NHS
SET name = REPLACE(name, '’', '''');

UPDATE NHS
SET name = REPLACE(name, '’S', '''s');

UPDATE NHS
SET name = REPLACE(name, 'Ooh', 'OOH');

UPDATE NHS
SET name = REPLACE(name, 'Foundation Trust', 'FT');

UPDATE NHS
SET name = REPLACE(name, 'And', '&');

UPDATE NHS
SET name = REPLACE(name, 'Pct', 'PCT');

UPDATE NHS
SET name = REPLACE(name, 'Primary Care Trust', 'PCT');

-- Do not automatically convert 'NHS Trust' to 'NHS FT'.
-- These are different legal organisation types and should only be mapped
-- using a verified organisation-name lookup table.
-- UPDATE NHS
-- SET name = REPLACE(name, 'NHS Trust', 'NHS FT');

UPDATE NHS
SET name = REPLACE(name, 'Gp', 'GP');

UPDATE NHS
SET name = REPLACE(name, 'Health Care', 'Healthcare');

UPDATE NHS
SET name = REPLACE(name, '.', '');

--RENAMING MONTH/YEAR COLUMNS TO BE DISTINCT FROM SQL SYNTAX

ALTER TABLE NHS 
RENAME COLUMN year TO year_value;
ALTER TABLE NHS 
RENAME COLUMN month TO month_value;

--UPDATING year AND month COLUMNS BASED UPON date

UPDATE NHS
SET month_value = (EXTRACT (MONTH FROM date)),
year_value = (EXTRACT (YEAR FROM date));

--CHECKING FOR NULL VALUES

SELECT COUNT(*) FROM NHS;
SELECT COUNT(*) FROM NHS WHERE name IS NULL;
SELECT COUNT(*) FROM NHS WHERE "Total attendances" IS NULL;
SELECT COUNT(*) FROM NHS WHERE date IS NULL;



SELECT * FROM NHS
WHERE name IS NULL;

--REMOVING VALUES WHERE NAME IS NULL (THESE ROWS ARE MISSING ALL DATA)

DELETE FROM NHS
WHERE name IS NULL;

--UPDATE MONTH AND YEAR COLUMNS TO INTEGERS INSTEAD OF TEXT

ALTER TABLE NHS
ALTER COLUMN month_value TYPE INTEGER
USING month_value:: INTEGER;

ALTER TABLE NHS
ALTER COLUMN year_value TYPE INTEGER
USING year_value:: INTEGER;


--IDENTIFYING DUPLICATE ROWS

SELECT date, name, COUNT(*) AS row_count
FROM NHS
GROUP BY date, name
HAVING COUNT(*) > 1
ORDER BY name;


SELECT ctid, *
FROM public.nhs
WHERE date = '2011-01-01'
  AND name = 'Airedale NHS FT';

SELECT ctid, *
FROM public.nhs
WHERE date = '2011-01-01'
  AND name = 'Berkshire East PCT';



--REMOVING DUPLICATE ROWS
-- Keep the row with the highest total attendance for each date/name pair.
-- NULL attendance values are ranked last. The ctid tie-breaker ensures that
-- exactly one row is retained when attendance totals are equal.

WITH ranked_rows AS (
    SELECT
        ctid,
        ROW_NUMBER() OVER (
            PARTITION BY date, name
            ORDER BY "Total attendances" DESC NULLS LAST, ctid
        ) AS row_num
    FROM NHS
)
DELETE FROM NHS AS n
USING ranked_rows AS r
WHERE n.ctid = r.ctid
  AND r.row_num > 1;

-- Confirm that no duplicate date/name pairs remain.
SELECT date, name, COUNT(*) AS row_count
FROM NHS
GROUP BY date, name
HAVING COUNT(*) > 1
ORDER BY name, date;


--Analysis

--SUMMARY--
SELECT
    COUNT(*) AS total_rows,
    MIN(date) AS earliest_date,
    MAX(date) AS latest_date,
    AVG("Total attendances") AS avg_total_attendances,
    AVG("Percentage in 4 hours or less (all)") AS avg_4hr_pct
FROM NHS;

--TRENDS BY YEAR

SELECT 
	year_value,
	SUM("Total attendances") AS total_attendances,
	AVG("Total attendances") AS avg_attendances_per_site,
	AVG("Percentage in 4 hours or less (all)") AS avg_under_4hr_pct,
	AVG("Number of patients spending >12 hours from decision to admit to admission") AS avg_num_over_12h
FROM NHS
GROUP BY year_value
ORDER BY year_value;


SELECT
    year_value,
    MIN("Percentage in 4 hours or less (all)") AS min_pct,
    AVG("Percentage in 4 hours or less (all)") AS avg_pct,
    MAX("Percentage in 4 hours or less (all)") AS max_pct
FROM public.nhs
GROUP BY year_value
ORDER BY year_value;

SELECT
    year_value,
    COUNT(*) AS rows_in_year,
    AVG("Percentage in 4 hours or less (all)") AS avg_pct,
    SUM("Percentage in 4 hours or less (all)") AS sum_pct
FROM public.nhs
GROUP BY year_value
ORDER BY year_value;


SELECT
    year_value,
    MIN("Percentage in 4 hours or less (all)") AS min_pct,
    AVG("Percentage in 4 hours or less (all)") AS avg_pct,
    MAX("Percentage in 4 hours or less (all)") AS max_pct
FROM public.nhs
GROUP BY year_value
ORDER BY year_value;


SELECT date, name, "Type 1 Departments - 4 hours to decision", "Type 2 Departments - 4 hours to decision", "Type 3 Departments - 4 hours to decision", "Percentage in 4 hours or less (all)", "Total attendances"
FROM public.nhs
WHERE year_value = 2016
ORDER BY "Percentage in 4 hours or less (all)" DESC;


SELECT
    year_value,
    SUM("Type 1 Departments - 4 hours to decision" 
	+ "Type 2 Departments - 4 hours to decision" 
	+ "Type 3 Departments - 4 hours to decision")
	/NULLIF(SUM("Total attendances"), 0) 
	* 100 
	AS percentage_left_within4
FROM NHS
GROUP BY year_value
ORDER BY year_value;

SELECT 
	year_value,
	COUNT(*) AS record_count,
	SUM("Total attendances") AS total_attendances,
	AVG("Number of patients spending >12 hours from decision to admit to admission") AS avg_num_wait_over12h,
	SUM("Number of patients spending >12 hours from decision to admit to admission") AS sum_wait_over12h,
	SUM("Number of patients spending >12 hours from decision to admit to admission")/NULLIF(SUM("Total attendances"), 0) * 100 AS perc_attendances_wait_over12h
FROM NHS
GROUP BY year_value
ORDER BY perc_attendances_wait_over12h DESC NULLS LAST;


--BEST/WORST PERFORMING HOSPITALS
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
	SUM("Number of patients spending >12 hours from decision to admit to admission")/NULLIF(SUM("Total attendances"), 0) * 100 AS perc_attendances_wait_over12h
FROM NHS
GROUP BY name
ORDER BY perc_attendances_wait_over12h DESC NULLS LAST;



--BY YEAR AND HOSPITAL--
SELECT 
	name,
	year_value,
	COUNT(*) AS record_count,
	SUM("Total attendances") AS total_attendances,
	AVG("Number of patients spending >12 hours from decision to admit to admission") AS avg_num_wait_over12h,
	SUM("Number of patients spending >12 hours from decision to admit to admission") AS sum_wait_over12h,
	SUM("Number of patients spending >12 hours from decision to admit to admission")/NULLIF(SUM("Total attendances"), 0) * 100 AS perc_attendances_wait_over12h
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






