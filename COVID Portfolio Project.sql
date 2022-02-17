Select *
From PortfolioProject..CovidVaccinations
Where Continent is not null
Order by 3,4

--Select *
--From PortfolioProject..CovidDeaths
--Order by 3,4

Select location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidVaccinations
Order by 1,2

Select conitnent, date, total_cases, total_deaths, (Total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidVaccinations
where location like '%States%'
Order by 1,2


Select continent, date, population, total_cases, (Total_cases/population)*100 as PercentPoplationInfected
From PortfolioProject..CovidVaccinations
--where location like '%States%'
Order by 1,2

Select continent, population, MAX(total_cases) as HighestInfectionCount,  Max((Total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidVaccinations
--where location like '%States%'
Group by continent, population
Order by PercentPopulationInfected desc

Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidVaccinations
--where location like '%States%'
Where Continent is not null
Group by location
Order by TotalDeathCount desc

------

Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidVaccinations
--where location like '%States%'
Where Continent is not null
Group by continent
Order by TotalDeathCount desc


---Global Numbers
Select SUM(new_cases) as total_cases, SUM(Cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_cases)*100 as DeathPercentage
From PortfolioProject..CovidVaccinations
--where location like '%States%'
Where continent is not null
--Group by date
Order by 1,2

--Total Population vs Vaccination

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Convert(int,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/Population)*100
From PortfolioProject..CovidDeaths vac
Join PortfolioProject..CovidVaccinations dea
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3

--*Using CTE
With PopvsVac (Continent, Location, Date, Population, new_vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, Sum(cAST(vac.new_vaccinations as BIGINT)) OVER (Partition by dea.location order by vac.location, vac.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/Population)*100
From PortfolioProject..CovidDeaths vac
Join PortfolioProject..CovidVaccinations dea
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac




-- TEMP TABLE

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)



Insert Into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, Sum(cAST(vac.new_vaccinations as BIGINT)) OVER (Partition by dea.location order by vac.location, vac.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/Population)*100
From PortfolioProject..CovidDeaths vac
Join PortfolioProject..CovidVaccinations dea
	On dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated



--Creating View to store data for later visualizations

Create View percentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, Sum(cAST(vac.new_vaccinations as BIGINT)) OVER (Partition by dea.location order by vac.location, vac.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/Population)*100
From PortfolioProject..CovidDeaths vac
Join PortfolioProject..CovidVaccinations dea
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3



Select *
From percentPopulationVaccinated