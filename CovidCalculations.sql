
Select location, date, total_cases, new_cases, total_deaths, population
From CovidDeaths
where continent is not null
Order By 1,2

-- Looking at total cases vs total deaths
-- Shows likelihood of dying if you contract covid in your country

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 As [Death_Percentage] 
From CovidDeaths
Where location like '%states%'And continent is not null
Order By 1,2

-- Looking at total cases vs population
-- shows what percentage of population got covid

Select location, date, total_cases, population, (total_cases/population)*100 As [Percent_population_Infected] 
From CovidDeaths
Where location like '%states%' And continent is not null
Order By 1,2

-- Looking at countries with highest infection rate compared to population

Select location, Max(total_cases) As [Highest Infection Count], population, Max((total_cases/population)*100) As [Percent_population_Infected] 
From CovidDeaths
where continent is not null
Group By location,population
Order By 4 Desc

-- Showing Countries with highest death count per population
-- Here total_deaths is not int, it is nvarchar.As total_deaths is an int value, we should convert it from nvarchar to int.
Select location, max(cast(total_deaths As int)) As [Total Death Count]
From CovidDeaths
where continent is not null
Group By location
Order By 2 Desc

-- Let's break things down by Continent 
Select location, max(cast(total_deaths As int)) As [Total Death Count]
From CovidDeaths
where continent is null
Group By location
Order By 2 Desc

-- Global cases, deaths count on daily basis
Select date, sum(new_cases) As Total_Cases, sum(cast(new_deaths As int)) As Total_Deaths, sum(cast(new_deaths As int))/sum(new_cases)*100 As Death_Percentage
From CovidDeaths
where continent is not null
Group By date
Order By 2 desc,3 desc 

-- Total Global cases & deaths
Select sum(new_cases) As Total_Cases, sum(cast(new_deaths As int)) As Total_Deaths, sum(cast(new_deaths As int))/sum(new_cases)*100 As Death_Percentage
From CovidDeaths
where continent is not null

-- Looking at total population vs vaccinations
Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
Sum(cast(vac.new_vaccinations as int)) Over (Partition By dea.location Order By dea.location,dea.date) As RollongPeopleVaccinated
From CovidDeaths dea
join CovidVaccinations vac
on dea.location=vac.location
And dea.date=vac.date
Where dea.continent is not null
Order By 1,2,3
