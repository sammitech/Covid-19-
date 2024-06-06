/*
Covid 19 Data Exploration 

Skills used: Aggregate Functions, Joins,Converting Data Types, CTEs, Temp tables

*/
Use[Covid] ;

Select *
From [dbo].[CovidDeaths]
Where continent is not null 
order by 3,4;

Select *
From [dbo].[CovidVaccinations]
Where continent is not null 
order by 3,4;

--show the summary of total cases and total death per country and per date.

Select Location, date, total_cases, new_cases, total_deaths, population
From [dbo].[CovidDeaths]
Where continent is not null 
order by population desc;


--what was the Likelyhood of death if you would get Covid in 2020 in USA

Select Location, date, total_cases, total_deaths, round((cast(total_deaths as float)/ cast(total_cases as float))*100,2) as DeathPercentage
From [dbo].[CovidDeaths]
Where location like '%states%' AND DATE LIKE '2020%'
and continent is not null 
order by DeathPercentage Desc;

--what percentage of population was infected by Covid in USA
Select top(1) Location, total_cases, round((cast(total_cases as float)/cast(population as float))*100,2) as PopulationPercentage
from [dbo].[CovidDeaths]
WHERE Location like '%states%'
order by total_cases Desc;


--which countries hav
Select Location, population, max(total_cases) as MaxCases, max(round((cast(total_cases as float)/cast(population as float))*100,2)) as MaxPercentage
from [dbo].[CovidDeaths]
group by Location, population
order by MaxPercentage Desc;e the highest infection rate?


--which countries have the highest death rate?
Select Location, population, max(total_deaths) as MaxDeaths
from [dbo].[CovidDeaths]
where continent is not null
group by Location, population
order by MaxDeaths Desc;

--which continents have the highest death count?

Select Location, population, max(total_deaths) as MaxDeaths
from [dbo].[CovidDeaths]
where continent is null and population is not null
group by Location, population
order by MaxDeaths Desc;


--what are total number of cases, total death number and total death percentage in the world:


Select sum(new_cases) as total_cases, sum(new_deaths) as total_deaths, round(sum(cast(new_deaths as float))/ sum(cast(new_cases as float)),4)*100 as DeathPercentage
From [dbo].[CovidDeaths]
where continent is not null;



--How many people in each country got vaccinated at least once?
--using CTE
WITH PopVsVac (continent, location, date, population, new_vaccinations, Rolling_people_vaccinated)
as 
(SELECT DEAT.continent, DEAT.location, DEAT.date, DEAT.population, VACCIN.new_vaccinations,
SUM(VACCIN.new_vaccinations) OVER (Partition by DEAT.location order by DEAT.location, DEAT.date) as Rolling_people_vaccinated
from [dbo].[CovidDeaths] as DEAT	
join [dbo].[CovidVaccinations] AS VACCIN
on DEAT.location = VACCIN.location
and DEAT.date = VACCIN.date
where DEAT.continent is not null 
group by DEAT.continent, DEAT.location, DEAT.date, DEAT.population, VACCIN.new_vaccinations
)
select *, CAST(Rolling_people_vaccinated AS FLOAT)/CAST(population AS FLOAT)*100 AS percentage_vaccinated, 
MAX(Rolling_people_vaccinated) OVER (PARTITION BY Location) as Max_people_vaccinated
from PopVsVac;


--How many people in each country got vaccinated at least once?
--using Temp table

DROP TABLE IF EXISTS #PercentPeopleVaccinated
Create table #PercentPeopleVaccinated
(continent nvarchar(255),
location nvarchar(255),
Date date,
population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPeopleVaccinated
SELECT DEAT.continent, DEAT.location, DEAT.date, DEAT.population, VACCIN.new_vaccinations,
SUM(VACCIN.new_vaccinations) OVER (Partition by DEAT.location order by DEAT.location, DEAT.date) as Rolling_people_vaccinated
from [dbo].[CovidDeaths] as DEAT	
join [dbo].[CovidVaccinations] AS VACCIN
on DEAT.location = VACCIN.location
and DEAT.date = VACCIN.date
where DEAT.continent is not null 
group by DEAT.continent, DEAT.location, DEAT.date, DEAT.population, VACCIN.new_vaccinations

select *
from #PercentPeopleVaccinated;


-- Creating View to store data for visualization

CREATE VIEW PercentPeopleVaccinated AS 
SELECT DEAT.continent, DEAT.location, DEAT.date, DEAT.population, VACCIN.new_vaccinations,
SUM(VACCIN.new_vaccinations) OVER (Partition by DEAT.location order by DEAT.location, DEAT.date) as Rolling_people_vaccinated
from [dbo].[CovidDeaths] as DEAT	
join [dbo].[CovidVaccinations] AS VACCIN
on DEAT.location = VACCIN.location
and DEAT.date = VACCIN.date
where DEAT.continent is not null 
group by DEAT.continent, DEAT.location, DEAT.date, DEAT.population, VACCIN.new_vaccinations


SELECT * 
FROM PercentPeopleVaccinated













