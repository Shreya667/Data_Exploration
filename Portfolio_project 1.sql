
select *
from portfolioproject..covidDeaths
where continent is not null
order by 3,4

--select *
--from portfolioproject..covidvaccinations
--order by 3,4

select location,date,total_cases,new_cases,total_deaths,population
from Portfolioproject..coviddeaths
order by 1,2

--total cases vs total deaths

select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as Deathpercentage
from Portfolioproject..coviddeaths
where location like '%states%'
order by 1,2


--percent of people got covid

select location, date, total_cases, population, (total_cases/population)* 100 as percentpopulationinfected
from portfolioproject..coviddeaths
order by 1,2 

--countries with highest infection rate compared to population 

select location, max(total_cases) as highestinfectioncount, population, max((total_cases/population))* 100 as percentpopulationinfected
from portfolioproject..coviddeaths
Group by location,population
order by percentpopulationinfected desc

--countries with highest death population per count

select location, max(cast(total_deaths as int)) as totaldeathcount
from portfolioproject..coviddeaths
Group by location
order by totaldeathcount desc



--continents with the highest death count per population

select continent, max(cast(total_deaths as int)) as totaldeathcount
from portfolioproject..coviddeaths
where continent is not null
group by continent 
order by totaldeathcount desc



select sum(new_cases) as total_cases,sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int)) / sum(new_cases) * 100 as deathpercentage
from portfolioproject..coviddeaths
where continent is not null
order by 1,2

--total population vs vaccinations

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,sum(convert(int,vac.new_vaccinations)) 
over (partition by dea.location order by dea.location,dea.date) as rollingpeoplevaccinated
from portfolioproject..coviddeaths dea
join portfolioproject..covidvaccinations vac
     on dea.location = vac.location
	 and dea.date = vac.date
where dea.continent is not null
order by 2,3

--USE CTE

with popvsvac (continent,location,date,population,new_vaccinations,rollingpeoplevaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,sum(convert(int,vac.new_vaccinations)) 
over (partition by dea.location order by dea.location,dea.date) as rollingpeoplevaccinated
from portfolioproject..coviddeaths dea
join portfolioproject..covidvaccinations vac
     on dea.location = vac.location
	 and dea.date = vac.date
where dea.continent is not null
)
select*, (rollingpeoplevaccinated/population)*100
from popvsvac

--TEMP TABLE
Drop table if exists #percentpopulationvaccinated
create table #percentpopulationvaccinated
( 
continent nvarchar(225),
location nvarchar (225),
date datetime,
population numeric,
new_vaccinations numeric,
rollingpeoplevaccinated numeric
)
Insert into #percentpopulationvaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,sum(convert(int,vac.new_vaccinations)) 
over (partition by dea.location order by dea.location,dea.date) as rollingpeoplevaccinated
from portfolioproject..coviddeaths dea
join portfolioproject..covidvaccinations vac
     on dea.location = vac.location
	 and dea.date = vac.date
--where dea.continent is not null

select*, (rollingpeoplevaccinated/population)*100
from #percentpopulationvaccinated


















