SELECT *
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1,2

SELECT *
FROM PortfolioProject..CovidVaccinations
ORDER BY 1,2

-- SELECT DATA THAT WE ARE GOING TO BE USING 
SELECT country, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject..CovidDeaths
ORDER BY 1,2

-- TOTAL CASES VS TOTAL DEATHS
SELECT country, date, total_cases, total_deaths, (total_deaths / NULLIF(total_cases, 0)) * 100 AS DeathPercentage
FROM PortfolioProject..CovidDeaths
--WHERE country like '%colombia%'
ORDER BY 1,2

--TOTAL CASES VS POPULATION
SELECT country, date, population, total_cases,  (total_cases / NULLIF(population, 0)) * 100 AS PercentagePopulationInfected
FROM PortfolioProject..CovidDeaths
--WHERE country like '%colombia%'
ORDER BY 1,2

--COUNTRY WITH THE HIGHEST INFECTION RATE COMPARE TO POPULATION
SELECT country, population, MAX(total_cases) AS HighestInfeCoun,  MAX((total_cases / population))* 100 AS HighestPercentagePopulationInfected
FROM PortfolioProject..CovidDeaths
--WHERE country like '%colombia%'
GROUP BY country, population
ORDER BY HighestPercentagePopulationInfected desc

--COUNTRY WITH HIGHEST DEATH COUNT PER POPULATION
SELECT country, MAX(total_deaths) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE TRIM(continent) <> '' -- Elimina espacios en blanco y filtra valores vacíos
AND continent IS NOT NULL -- Asegura que no sea NULL
GROUP BY country
ORDER BY TotalDeathCount desc