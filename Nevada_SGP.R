#######################################################################
###
### Script for analyzing Nevada Data
###
#######################################################################

################################
### Load SGP Package
################################

require(SGP)
options(error=recover)


################################
### Load Data
################################

load("Data/Old_Stuff/Nevada_SGP.Rdata")
load("Data/Nevada_Data_LONG.Rdata")


#######################################################################
### Subdivide Nevada_Data_LONG into pre 2011_2012 and 2011_2012
#######################################################################

Nevada_Data_LONG$ID <- as.character(Nevada_Data_LONG$ID)
Nevada_Data_LONG$STATE_UNIQUE_ID <- as.character(Nevada_Data_LONG$STATE_UNIQUE_ID)
Nevada_Data_LONG$CONTENT_AREA <- as.character(Nevada_Data_LONG$CONTENT_AREA)
Nevada_Data_LONG$YEAR <- as.character(Nevada_Data_LONG$YEAR)
Nevada_Data_LONG$VALID_CASE <- as.character(Nevada_Data_LONG$VALID_CASE)

Nevada_Data_LONG_PRE_2011_2012 <- subset(Nevada_Data_LONG, YEAR!="2011_2012") 
Nevada_Data_LONG_2011_2012 <- subset(Nevada_Data_LONG, YEAR=="2011_2012") 


################################################
### Embed Nevada_Data_LONG into Nevada_SGP
################################################

Nevada_SGP_NEW <- prepareSGP(Nevada_Data_LONG_PRE_2011_2012)
Nevada_SGP@Data <- Nevada_SGP_NEW@Data


####################################################
### NULL out stuff to be re-calculated
####################################################

Nevada_SGP@SGP$Goodness_of_Fit <- NULL
Nevada_SGP@SGP$SGPercentiles <- NULL
Nevada_SGP@SGP$SGProjections <- NULL
Nevada_SGP@SGP$Simulated_SGPs <- NULL
Nevada_SGP@Summary <- NULL

### Save results

save(Nevada_SGP, file="Data/Nevada_SGP.Rdata")


#####################################
### Run analyses on Nevada Data
#####################################

Nevada_SGP@Data$ACHIEVEMENT_LEVEL <- NULL

### prepareSGP

Nevada_SGP <- prepareSGP(Nevada_SGP)


### analyzeSGP PRE 2011_2012

Nevada_SGP <- analyzeSGP(
	Nevada_SGP,
	simulate.sgps=FALSE,
	sgp.use.my.coefficient.matrices=TRUE,
	parallel.config=list(BACKEND="PARALLEL", WORKERS=list(PERCENTILES=10, BASELINE_PERCENTILES=10, PROJECTIONS=10, LAGGED_PROJECTIONS=10)))

save(Nevada_SGP, file="Data/Nevada_SGP.Rdata")


### analyzeSGP 2011_2012

Nevada_SGP@Data <- as.data.table(rbind.fill(Nevada_SGP@Data, Nevada_Data_LONG_2011_2012))
setkey(Nevada_SGP@Data, VALID_CASE, CONTENT_AREA, YEAR, ID)

Nevada_SGP <- analyzeSGP(
	Nevada_SGP,
	years="2011_2012",
	simulate.sgps=FALSE,
	parallel.config=list(BACKEND="PARALLEL", WORKERS=list(PERCENTILES=20, BASELINE_PERCENTILES=20, PROJECTIONS=8, LAGGED_PROJECTIONS=8)))

save(Nevada_SGP, file="Data/Nevada_SGP.Rdata")


### combineSGP

Nevada_SGP <- combineSGP(Nevada_SGP)


### summarizeSGP

Nevada_SGP <- summarizeSGP(Nevada_SGP, parallel.config=list(BACKEND="PARALLEL", WORKERS=list(SUMMARY=30)))


### visualizeSGP

visualizeSGP(
	Nevada_SGP, 
	sgPlot.demo.report=TRUE,
	parallel.config=list(BACKEND="PARALLEL", WORKERS=list(GA_PLOTS=10, SG_PLOTS=1)))


### outputSGP

outputSGP(
	Nevada_SGP,
	output.type=c("LONG_Data", "WIDE_Data"))


### save results

save(Nevada_SGP, file="Data/Nevada_SGP.Rdata")
