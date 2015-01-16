###########################################################
###
### Nevada SGP Analysis for 2014
###
###########################################################

### Load SGP Package

require(SGP)


### Load previous SGP object and 2014 data

load("Data/Nevada_SGP.Rdata")
load("Data/Nevada_Data_LONG_2013_2014.Rdata")


### Update SGPs

Nevada_SGP <- updateSGP(
			Nevada_SGP,
			Nevada_Data_LONG_2013_2014,
			sgPlot.demo.report=TRUE,
			parallel.config=list(BACKEND="PARALLEL", WORKERS=list(PERCENTILES=10, BASELINE_PERCENTILES=10, PROJECTIONS=10, LAGGED_PROJECTIONS=10, SUMMARY=10, GA_PLOTS=4, SG_PLOTS=1)))


### Save results

save(Nevada_SGP, file="Data/Nevada_SGP.Rdata")
