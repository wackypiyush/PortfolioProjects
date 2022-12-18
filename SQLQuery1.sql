
/*select * from PortfolioProject..CovidDeaths
order by 3,4

select Location,date,total_cases,new_cases,total_deaths,population
from PortfolioProject..CovidDeaths
order by 1,2

--Looking at total cases VS total deaths
--Shows likelihood of dying if you contract covid in your country
select Location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as Death_Percentage
from PortfolioProject..CovidDeaths
where location like '%states%'
order by 1,2 

--Looking at total cases VS population
-- shows waht percentage of population got Covid
select Location,date,population,total_cases, (total_cases/population)*100 as Infection_Percentage
from PortfolioProject..CovidDeaths
where location like '%states%'
order by 1,2 

--Looking at Countries with Highest Infection Rate compared to Population
select Location,population,MAX(total_cases) as HighestInfectionCount ,MAX((total_cases/population))*100 as PercentPopulationInfected
from PortfolioProject..CovidDeaths
Group by  Location,population
order by PercentPopulationInfected desc 

--Looking at Countries with Highest Death count per Population
select Location, max(cast(Total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
where continent is not null
Group by  Location
order by TotalDeathCount desc 

--Looking things by Continent
select continent, max(cast(Total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
where continent is not null
Group by  continent
order by TotalDeathCount desc 

--Showing Continents with highest DeathCount per population
select continent, max(cast(Total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
where continent is not null
Group by  continent
order by TotalDeathCount desc 

--GLOBAL NUMBERS
select sum(new_cases) as Total_cases, sum(cast(new_deaths as int)) as Total_Deaths, sum(cast(new_deaths as int))/sum(new_cases) *100 as Death_Percentage
from PortfolioProject..CovidDeaths
where continent is not null
--Group by date
order by 1,2   


--Looking at Total population VS vaccinations



select dea.continent,dea.location,dea.date,dea.population,vca.new_vaccinations,
sum(convert(bigint,vca.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccination
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccination vca
on dea.location=vca.location
and dea.date=vca.date
where dea.continent is not null
order by 2,3 */

-- To perform task on currently made column
with pop (continent, location, date, population,vaccinations, RollingPeopleVaccination)
as
(
select dea.continent,dea.location,dea.date,dea.population,vca.new_vaccinations,
sum(convert(bigint,vca.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccination
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccination vca
on dea.location=vca.location
and dea.date=vca.date
where dea.continent is not null
--order by 2,3
)

select *, (RollingPeopleVaccination /population)*100 as TotalVaccinatedPopulationPercentage
from pop

--Creating a view

go
CREATE VIEW
PercentPopulationVaccinated
as
select dea.continent,dea.location,dea.date,dea.population,vca.new_vaccinations,
sum(convert(bigint,vca.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccination
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccination vca
on dea.location=vca.location
and dea.date=vca.date
where dea.continent is not null
--order by 2,3
go

select * from PercentPopulationVaccinated