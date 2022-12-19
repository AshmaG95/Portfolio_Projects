/*
Covid 19 Data Exploration 
Skills used: Joins, CTE's, Temp Tables, Aggregate Functions, Creating Views, Converting Data Types
*/

USE Portfolio_Project

SELECT *
FROM Portfolio_Project..CovidDeaths
ORDER BY 3,4

SELECT *
FROM Portfolio_Project..CovidVaccinations
ORDER BY 3,4

--Select Data that we are going to be using 

SELECT Location, date, total_cases, new_cases,total_deaths, population
FROM Portfolio_Project .. CovidDeaths
ORDER BY 1,2

--Looking at Total Cases vs Total Deaths
-- Total Death percentage in each country

SELECT Location, date, total_cases, total_deaths,(total_deaths/total_cases)*100 AS Death_Percentage
FROM Portfolio_Project .. CovidDeaths
WHERE Location like 'United Kingdom'
ORDER BY 1,2

-- Total Cases Vs Population
-- Shows what percentage of population got Covid

SELECT Location, date,population,total_cases,(total_cases/population)*100 AS Percent_Population_Infected
FROM Portfolio_Project .. CovidDeaths
WHERE Location like 'United Kingdom'
ORDER BY 1,2

-- Countries with Highest Infection rate compared to Population

SELECT Location,population,MAX(total_cases) AS Highest_Infection_Count,MAX(total_cases/population)*100 AS Percent_Population_Infected
FROM Portfolio_Project .. CovidDeaths
--WHERE Location like 'United Kingdom'
GROUP BY Location, population 
ORDER BY Percent_Population_Infected DESC

-- Countries with Highest Death Count per Population

SELECT Location,MAX(cast(total_deaths AS int)) AS Total_Death_Count
FROM Portfolio_Project .. CovidDeaths
--WHERE Location like 'United Kingdom'
WHERE continent IS NOT NULL
GROUP BY Location
ORDER BY Total_Death_Count desc

--Breaking things down by continent
--Showing continents with the highest death count per population 

SELECT continent,SUM(CAST(new_deaths AS int))AS Total_Death_Count
FROM Portfolio_Project .. CovidDeaths
--WHERE Location like 'United Kingdom'
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY Total_Death_Count desc

--Global Numbers

SELECT date, SUM(new_cases) AS total_cases, SUM(CAST(new_deaths AS int)) AS total_deaths, SUM(CAST(new_deaths AS int))/SUM(new_cases) *100 AS Death_Percentage
FROM Portfolio_Project .. CovidDeaths
--WHERE Location like 'United Kingdom'
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1,2


-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location,
  dea.date) AS Rolling_People_Vaccinated

FROM Portfolio_Project..CovidDeaths dea
JOIN Portfolio_Project..CovidVaccinations vac
     ON dea.location = vac.location
	 AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2,3


--CTE

WITH PopvsVac (Continent, location, date, population,new_vaccinations,Rolling_People_Vaccinated)
AS
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location,
  dea.date) AS Rolling_People_Vaccinated

FROM Portfolio_Project..CovidDeaths dea
JOIN Portfolio_Project..CovidVaccinations vac
     ON dea.location = vac.location
	 AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
--ORDER BY 2,3
)
SELECT *, (Rolling_People_Vaccinated/population)* 100
FROM PopvsVac

--Tempt Table

DROP TABLE IF exists #Percent_Population_Vaccinated
CREATE TABLE #Percent_Population_Vaccinated
(
Continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
Rolling_People_Vaccinated numeric
)

INSERT INTO #Percent_Population_Vaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location,
  dea.date) AS Rolling_People_Vaccinated

FROM Portfolio_Project..CovidDeaths dea
JOIN Portfolio_Project..CovidVaccinations vac
     ON dea.location = vac.location
	 AND dea.date = vac.date
--WHERE dea.continent IS NOT NULL
--ORDER BY 2,3

SELECT *, (Rolling_People_Vaccinated/population)* 100
FROM #Percent_Population_Vaccinated

--Creating View to store data for later visualisations

CREATE VIEW Percent_Population_Vaccinated AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location,
  dea.date) AS Rolling_People_Vaccinated

FROM Portfolio_Project..CovidDeaths dea
JOIN Portfolio_Project..CovidVaccinations vac
     ON dea.location = vac.location
	 AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
--ORDER BY 2,3

SELECT *
FROM Percent_Population_Vaccinated