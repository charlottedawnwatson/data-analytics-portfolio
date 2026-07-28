/*
COVID Data Exploration with PostgreSQL

Objective:
Explore global COVID deaths and vaccination trends using PostgreSQL.

Dataset:
Our World in Data COVID Dataset

Key Analysis:
- Death percentage by country
- Infection rates
- Vaccination rates
- Global yearly trends
- Running vaccination totals using window functions

Skills Demonstrated:
- PostgreSQL
- Joins
- Views
- CTEs
- Window Functions
- Aggregations
*/

DROP TABLE IF EXISTS covid_deaths;

CREATE TABLE covid_deaths (
    country TEXT,
    date DATE,
    population NUMERIC,
    total_cases NUMERIC,
    new_cases NUMERIC,
    new_cases_smoothed NUMERIC,
    total_cases_per_million NUMERIC,
    new_cases_per_million NUMERIC,
    new_cases_smoothed_per_million NUMERIC,
    total_deaths NUMERIC,
    new_deaths NUMERIC,
    new_deaths_smoothed NUMERIC,
    total_deaths_per_million NUMERIC,
    new_deaths_per_million NUMERIC,
    new_deaths_smoothed_per_million NUMERIC,
    excess_mortality NUMERIC,
    excess_mortality_cumulative NUMERIC,
    excess_mortality_cumulative_absolute NUMERIC,
    excess_mortality_cumulative_per_million NUMERIC,
    hosp_patients NUMERIC,
    hosp_patients_per_million NUMERIC,
    weekly_hosp_admissions NUMERIC,
    weekly_hosp_admissions_per_million NUMERIC,
    icu_patients NUMERIC,
    icu_patients_per_million NUMERIC,
    weekly_icu_admissions NUMERIC,
    weekly_icu_admissions_per_million NUMERIC,
    stringency_index NUMERIC,
    reproduction_rate NUMERIC,
    total_tests NUMERIC
);

DROP TABLE IF EXISTS covid_vaccines;

CREATE TABLE covid_vaccines (
    country TEXT,
    date DATE,
    icu_patients NUMERIC,
    icu_patients_per_million NUMERIC,
    weekly_icu_admissions NUMERIC,
    weekly_icu_admissions_per_million NUMERIC,
    stringency_index NUMERIC,
    reproduction_rate NUMERIC,
    total_tests NUMERIC,
    new_tests NUMERIC,
    total_tests_per_thousand NUMERIC,
    new_tests_per_thousand NUMERIC,
    new_tests_smoothed NUMERIC,
    new_tests_smoothed_per_thousand NUMERIC,
    positive_rate NUMERIC,
    tests_per_case NUMERIC,
    total_vaccinations NUMERIC,
    people_vaccinated NUMERIC,
    people_fully_vaccinated NUMERIC,
    total_boosters NUMERIC,
    new_vaccinations NUMERIC,
    new_vaccinations_smoothed NUMERIC,
    total_vaccinations_per_hundred NUMERIC,
    people_vaccinated_per_hundred NUMERIC,
    people_fully_vaccinated_per_hundred NUMERIC,
    total_boosters_per_hundred NUMERIC,
    new_vaccinations_smoothed_per_million NUMERIC,
    new_people_vaccinated_smoothed NUMERIC,
    new_people_vaccinated_smoothed_per_hundred NUMERIC,
    code TEXT,
    continent TEXT,
    population_density NUMERIC,
    median_age NUMERIC,
    life_expectancy NUMERIC,
    gdp_per_capita NUMERIC,
    extreme_poverty NUMERIC,
    diabetes_prevalence NUMERIC,
    handwashing_facilities NUMERIC,
    hospital_beds_per_thousand NUMERIC,
    human_development_index NUMERIC
);

--No Deaths Per Infections in UK
SELECT
    country,
    date,
    total_cases,
    total_deaths,
    population,
    (total_deaths / NULLIF(total_cases, 0)) * 100 AS death_percentage
FROM covid_deaths
WHERE country = 'United Kingdom'
ORDER BY date;

--Global Cases by Year
SELECT
    EXTRACT(YEAR FROM date) AS year,
    SUM(new_cases) AS total_new_cases
FROM covid_deaths
WHERE country NOT IN (
    'World',
    'Europe',
    'Asia',
    'Africa',
    'North America',
    'South America',
    'Oceania'
)
GROUP BY EXTRACT(YEAR FROM date)
ORDER BY year;

DROP VIEW IF EXISTS covid_combined;

CREATE VIEW covid_combined AS
SELECT v.country, 
v.date, 
v.total_tests, 
v.new_tests, 
v.people_fully_vaccinated, 
v.new_vaccinations, 
v.continent, 
d.new_cases,
d.total_cases,
d.total_deaths, 
d.new_deaths,
d.population
FROM covid_vaccines v INNER JOIN covid_deaths d
ON v.country = d.country
AND v.date = d.date;


SELECT
EXTRACT(year FROM date) as years, 
EXTRACT(month FROM date) as months,
max(people_fully_vaccinated) AS total_vaccinated,
SUM(new_vaccinations) AS new_vaccines,
SUM(new_cases) AS cases_count,
SUM(new_deaths) AS death_count
FROM covid_combined
GROUP BY years, months;

--Total  Population Vaccinated By Year
SELECT 
EXTRACT(YEAR from date) AS years,
SUM(new_vaccinations),
SUM(new_vaccinations)/NULLIF(MAX(population),0) * 100 AS perc_vaccinated
FROM covid_combined
WHERE country = 'World'
GROUP BY years;


--Total  Population Vaccinated By Country
SELECT 
country,
population,
SUM(new_vaccinations),
SUM(new_vaccinations)/NULLIF(MAX(population),0) * 100 AS perc_vaccinated
FROM covid_combined
WHERE continent IS NOT NULL
GROUP BY country, population
ORDER BY perc_vaccinated DESC NULLS LAST;


--People Fully Vaccinated By Country
SELECT 
country,
population,
MAX(people_fully_vaccinated) AS total_vaccinated,
MAX(people_fully_vaccinated)/NULLIF(MAX(population),0) * 100 AS perc_vaccinated
FROM covid_combined
WHERE continent IS NOT NULL
GROUP BY country, population
ORDER BY perc_vaccinated DESC NULLS LAST;


--Summation of vaccinations by country and date compared to population
WITH popvsvac (country, population, date, new_vaccinations, vaccine_summation) AS (
SELECT 
country,
population,
date,
new_vaccinations,
SUM(new_vaccinations) OVER (PARTITION BY country ORDER BY date) AS vaccine_summation
FROM covid_combined)

SELECT country, 
date, 
vaccine_summation, 
vaccine_summation/population * 100 AS perc_pop_vaccinated
FROM popvsvac
ORDER BY date, country
;

--Summation of vaccinations by country and date compared to population AND NEW CASES

DROP VIEW IF EXISTS vaccine_summation_vs_new_cases;

CREATE VIEW vaccine_summation_vs_new_cases AS 

WITH popvsvac (country, population, date, new_vaccinations,  new_cases, vaccine_summation) AS (
SELECT 
country,
population,
date,
new_vaccinations,
new_cases,
SUM(new_vaccinations) OVER (PARTITION BY country ORDER BY date) AS vaccine_summation
FROM covid_combined)

SELECT country, 
date, 
vaccine_summation, 
vaccine_summation/NULLIF((population), 0) * 100 AS perc_pop_vaccinated,
new_cases
FROM popvsvac
;


