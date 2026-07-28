# COVID-19 Data Exploration with PostgreSQL

## Project Overview

This project explores global COVID-19 deaths and vaccination trends using PostgreSQL. It uses the Our World in Data COVID dataset to analyse deaths, infection rates, vaccination progress, and year-by-year global trends.

The project includes table creation, joins, views, CTEs, aggregations, and window functions to build a clear SQL workflow for exploring public health data.

## Objectives

* Explore COVID-19 death and infection patterns by country and over time
* Analyse vaccination trends globally and by country
* Calculate death percentage, infection rates, and vaccination coverage
* Use SQL techniques such as joins, views, CTEs, window functions, and aggregations

## Dataset

**Source:** Our World in Data COVID Dataset

The project uses two main tables:

* `covid_deaths`
* `covid_vaccines`

These tables are joined into a combined view for analysis of deaths, tests, and vaccination metrics.

## Key Analysis

* Death percentage by country
* Infection rates
* Vaccination rates
* Global yearly trends
* Running vaccination totals using window functions
* Population vaccination comparisons by country
* Fully vaccinated population analysis

## SQL Techniques Used

* `CREATE TABLE`
* `DROP TABLE IF EXISTS`
* `CREATE VIEW`
* `JOIN`
* `CTE`
* `SUM() OVER (PARTITION BY ...)`
* `GROUP BY`
* `EXTRACT()`
* `NULLIF()`
* Aggregation and filtering

## Skills Demonstrated

* PostgreSQL
* SQL querying
* Joins
* Views
* CTEs
* Window Functions
* Aggregations
* Data Exploration

## Example Questions Explored

* What is the death percentage for a specific country?
* How did global cases change by year?
* How many people have been vaccinated by country?
* What is the running total of vaccinations over time?
* How do vaccination totals compare with new cases?

## Notes

* This project focuses on data exploration and reporting in SQL.
* The queries are written to be reusable for further analysis or dashboarding.

## Tableau Dashboard
This project also includes a Tableau dashboard that visualises COVID-19 deaths, cases, and vaccination trends by country and over time.
https://public.tableau.com/app/profile/charlotte.watson4244/viz/COVIDDashboard-InitialAnalysis/Dashboard1?publish=yes

The dashboard highlights:
- Percentage Population Infected Per Country
- Deaths by Continent
- Global Vaccinations VS Cases Over Time
