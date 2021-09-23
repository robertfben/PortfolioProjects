select *
from CovidDeaths
where continent is not null
order by 3,4

--Select *
--from CovidVaccinations
--order by 3,4

-- Select Data to be used

Select Location, date, total_Cases, new_Cases, total_deaths, population
from CovidDeaths
order by 1,2


-- Total Cases vs Total Deaths (Mortality of those who had COVID)
-- mortality of those who had covid in US
Select Location, date, total_cases, total_Deaths, round((total_deaths/total_cases)*100,4) as 'DeathPercentage'
from CovidDeaths
where Location like '%states%'
order by 1,2


-- Looking at Total Cases vs Population
-- Shows what percentage of population contracted COVID

Select Location, date, total_cases, Population, round((total_cases/population)*100,4) as 'PercentPopulationInfected'
from CovidDeaths
--where Location like '%states%'
order by 1,2


-- Looking at countries with highest infection rate compared to Population


Select Location, Population, max(total_cases) as 'HighestInfectionCount', max(round((total_cases/population)*100,4)) as 'PercentPopulationInfected'
from CovidDeaths
--where Location like '%states%'
group by Location, Population
order by 'PercentPopulationInfected' desc


-- Countries with Highest Death Count per Population


Select Location, max(cast(total_deaths as int)) as 'TotalDeathCount'
from CovidDeaths
--where Location like '%states%'
where continent is not null
group by Location
order by 'TotalDeathCount' desc


-- Continents with Highest Death Count per Population

Select continent, max(cast(total_deaths as int)) as 'TotalDeathCount'
from CovidDeaths
--where Location like '%states%'
where continent is not null
group by Continent
order by 'TotalDeathCount' desc


-- || Global Numbers ||


Select sum(new_cases) 'total_cases', sum(cast(new_Deaths as int)) 'total_Deaths', sum(cast(new_Deaths as int))/sum(new_cases)*100 'DeathPercentage'
from CovidDeaths
-- where location like '%states%'
where continent is not null
-- Group by date
order by 1,2


-- Total Population vs Vaccinations


Select d.continent, d.location, d.date, d.population, v.new_vaccinations
, sum(cast(v.new_vaccinations as int)) over (Partition by d.location order by d.location,d.date) as 'RollingPeopleVaccinated'
from CovidDeaths d
join CovidVaccinations v
	on d.location = v.location
	and d.date = v.date
	where d.continent is not null
order by 2,3



-- USE CTE


With PopvsVac (Continent, Location, Date, Population, new_vaccinations, RollingPeopleVaccinated)
as 
(
Select d.continent, d.location, d.date, d.population, v.new_vaccinations
, sum(cast(v.new_vaccinations as int)) over (Partition by d.location order by d.location,d.date) as 'RollingPeopleVaccinated'
from CovidDeaths d
join CovidVaccinations v
	on d.location = v.location
	and d.date = v.date
	where d.continent is not null
-- order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
from PopvsVac


-- TEMP TABLE


DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
RollingPeopleVaccinated numeric
)
Insert into #PercentPopulationVaccinated
Select d.continent, d.location, d.date, d.population, v.new_vaccinations
, sum(cast(v.new_vaccinations as int)) over (Partition by d.location order by d.location,d.date) as 'RollingPeopleVaccinated'
from CovidDeaths d
join CovidVaccinations v
	on d.location = v.location
	and d.date = v.date
	where d.continent is not null
-- order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
from #PercentPopulationVaccinated




-- Creating View to store data for later visualizations


Create View PercentPopulationVaccinated as


Select d.continent, d.location, d.date, d.population, v.new_vaccinations
, sum(cast(v.new_vaccinations as int)) over (Partition by d.location order by d.location,d.date) as 'RollingPeopleVaccinated'
from CovidDeaths d
join CovidVaccinations v
	on d.location = v.location
	and d.date = v.date
	where d.continent is not null
-- order by 2,3

