# PostgreSQL Data Quality Cleaning

## Project Overview

This project demonstrates SQL data cleaning and transformation techniques on a real-world housing dataset.

The goal of the project is to clean, standardise, and prepare the dataset for analysis and visualisation in BI tools or for further statistical modelling.

## Dataset

This project uses a Nashville housing dataset containing property, sale, and owner information.

## Cleaning Tasks Performed

* Created and structured a relational database table
* Converted the sale date from text to a proper date format
* Filled missing `PropertyAddress` values using matching `ParcelID` records
* Split property address fields into separate address and city columns
* Split owner address fields into separate address, city, and state columns
* Standardised the `SoldAsVacant` column from `Y/N` values to `Yes/No`
* Identified and removed duplicate records using `ROW_NUMBER()` and a CTE
* Dropped unnecessary columns to simplify the final dataset

## SQL Techniques Used

* `CREATE TABLE`
* `ALTER TABLE`
* `UPDATE`
* `COALESCE`
* `CASE`
* `SPLIT_PART`
* `CTE`
* `ROW_NUMBER() OVER (...)`
* `DELETE`
* `DROP COLUMN`

## Skills Demonstrated

* PostgreSQL
* Data cleaning
* Data transformation
* Handling missing values
* String manipulation
* Duplicate removal
* Relational database structure
* SQL window functions

## Outcome

The final dataset is cleaned, standardised, and ready for use in dashboarding, reporting, or further analysis.

## Notes

This project focuses on data preparation rather than analysis. It is designed to show practical SQL skills that support analytics and data quality workflows.
