select *
from PortfolioProject..CovidDeaths
order by 4,5 


-- where continent is not null

--select *
--from PortfolioProject..CovidVaccinations
--order by 4,5 


select location,date,total_cases,new_cases,total_deaths,population
from PortfolioProject..CovidDeaths
where continent is not null
order by 1,2


-- Looking at total cases va total deaths 


select location,date,total_cases,total_deaths, ((total_deaths*10000.00)/total_cases)  /100 as DeathPercentage
from PortfolioProject..CovidDeaths
where location  like '%states%'
and  continent is not null
order by 1,2


--Looking at Total Cases vs Population
-- Shows what pecentage of population got covid

select location,date,population, total_cases,((total_cases*10000.00)/population)  /100 as Percentpopulationinfected
from PortfolioProject..CovidDeaths
-- where location  like '%states%'
where continent is not null
order by 1,2



-- Looking at Countries with Highest Infection Rate compared to Poplation 

select location,population, max(total_cases) as HighestInfectionCount,max(((total_cases*10000.00)/population)  /100) as Percentpopulationinfected
from PortfolioProject..CovidDeaths
--where location  like '%states%'
group by location,population
order by Percentpopulationinfected desc



-- Showing Countries with Highest Death Count per Population

select Location,MAX(cast(total_deaths as  int)) as TotalDeathCount 
from PortfolioProject..CovidDeaths
--where location  like '%states%'
where continent is not null
group by location
order by TotalDeathCount desc

-- And we can break things down by Continent

select location,MAX(cast(total_deaths as  int)) as TotalDeathCount 
from PortfolioProject..CovidDeaths
where continent is null
group by location
order by TotalDeathCount desc

-- because the results are mixed with other category, we need to change our query a little bit

-- Showing continents with the highest death count 

select location,MAX(cast(total_deaths as  int)) as TotalDeathCount 
from PortfolioProject..CovidDeaths
where continent is null and location not in  ('World','High income','Upper middle income', 'Lower middle income','Low income')
group by location
order by TotalDeathCount desc




-- Global Numbers for each single day

select date,sum(new_cases)as total_new_cases,sum(new_deaths)as total_new_deaths, (sum(cast(new_deaths as float))/sum(cast(new_cases as float)))*100 as DeathPercentage
from PortfolioProject..CovidDeaths
--where location  like '%states%'
where  continent is not null
group by date 
order by 1,2

-- Global total number (accumulated)

select sum(new_cases)as total_new_cases,sum(new_deaths)as total_new_deaths, (sum(cast(new_deaths as float))/sum(cast(new_cases as float)))*100 as DeathPercentage
from PortfolioProject..CovidDeaths
--where location  like '%states%'
where  continent is not null

order by 1,2


-- Looking at Total Population vs Vaccinations

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(vac.new_vaccinations)over (partition by dea.location order by dea.location , dea.date) as RollingVaccinated
from PortfolioProject..CovidDeaths dea
join  PortfolioProject..CovidVaccinations vac 
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3


-- CTE method

with PopvsVac (Continent, Location, Date, Population, New_Vaccinations, ProllingVaccinated)
as 
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(vac.new_vaccinations)over (partition by dea.location order by dea.location , dea.date) as RollingVaccinated
from PortfolioProject..CovidDeaths dea
join  PortfolioProject..CovidVaccinations vac 
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
select *,(cast(ProllingVaccinated as float)/cast(Population as float))*100
from PopvsVac



-- Temp Table
DROP table if exists #PercentPopulationVaccinated

Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
RollingVaccinated numeric
)

insert into #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(vac.new_vaccinations)over (partition by dea.location order by dea.location , dea.date) as RollingVaccinated
from PortfolioProject..CovidDeaths dea
join  PortfolioProject..CovidVaccinations vac 
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3


select *,(cast(RollingVaccinated as float)/cast(Population as float))*100
from #PercentPopulationVaccinated





-- creating view to store data for later visualizations
DROP View if exists PercentPopulationVaccinated
create View PercentPopulationVaccinated as 
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(vac.new_vaccinations)over (partition by dea.location order by dea.location , dea.date) as RollingVaccinated
from PortfolioProject..CovidDeaths dea
join  PortfolioProject..CovidVaccinations vac 
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3


-- use the view  we just create

select *
from PercentPopulationVaccinated