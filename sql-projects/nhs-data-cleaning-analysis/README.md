# NHS Emergency Care Data Quality and Performance Analysis

## Project overview

This PostgreSQL project cleans, validates, transforms and analyses longitudinal NHS emergency-care operational data. It demonstrates a reproducible workflow for preparing complex healthcare data, documenting quality decisions and producing operational insights.

The project is relevant to junior clinical programming and healthcare analytics roles because it applies SQL to data extraction, cleaning, aggregation, validation and reporting. The dataset concerns NHS emergency-care operations rather than clinical-trial participant data.



Data Source: https://www.kaggle.com/datasets/treich/ae-attendances-england



## Objectives

* Standardise inconsistent NHS organisation names.
* derive reliable month and year fields from reporting dates.
* identify missing and duplicate records.
* retain one defensible record for each organisation and reporting date.
* validate the cleaned dataset before analysis.
* analyse attendance volumes, four-hour performance and waits exceeding 12 hours.



## Tools and SQL techniques

* PostgreSQL
* schema creation and data-type conversion
* string standardisation
* date extraction
* null and duplicate checks
* common table expressions
* `ROW\_NUMBER()` window functions
* conditional calculations with `NULLIF`
* grouped time-series aggregation
* validation queries and documented assumptions

## Important data-quality decisions

### Duplicate handling

Records are considered potential duplicates when they share the same `date` and `name`. Within each pair, the record with the highest `Total attendances` value is retained. Null attendance values are ranked last, and PostgreSQL's `ctid` is used only as a deterministic tie-breaker during this one-time cleaning step.

This rule is a project assumption and should be confirmed against source-system specifications in a production environment.

### Organisation names

The script standardises common abbreviations and punctuation. It deliberately does **not** automatically replace `NHS Trust` with `NHS FT`, because NHS Trusts and NHS Foundation Trusts are different legal organisation types. 

## Analysis included

* overall row count and reporting-date coverage
* annual total and average attendances
* annual four-hour performance
* minimum, average and maximum performance by year
* estimated percentage of attendances completed within four hours
* number and percentage of attendances associated with waits exceeding 12 hours
* organisation-level performance review for a selected year

## Validation approach

The project checks:

* row counts and date coverage
* missing organisation names, dates and attendance values
* invalid month and year derivations
* duplicate organisation-date combinations
* percentage values outside the expected 0–100 range
* negative numerical values
* successful removal of duplicate keys


## Portfolio summary

Developed a repeatable PostgreSQL workflow to clean, transform, validate and analyse NHS emergency-care data. Used string standardisation, date transformations, CTEs and window functions to resolve data-quality issues, then produced time-series measures of attendance demand and waiting-time performance.

