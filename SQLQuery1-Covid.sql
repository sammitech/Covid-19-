/*
Covid 19 Data Exploration 

Skills used: Aggregate Functions, Joins,Converting Data Types

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


--which countries have the highest infection rate?


--which countries have the highest death rate?














