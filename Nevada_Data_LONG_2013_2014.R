#####################################################################
###
### Script for producing LONG file
###
#####################################################################

### Load SGP package

require(data.table)


### Load table

Nevada_Data_LONG_2013_2014 <- fread("Data/Base_Files/Nevada_Data_LONG_2013_2014.txt")
EMH_LEVELs_2013_2014 <- fread("Data/Base_Files/EMH_LEVEL_2014.csv")

### Tidy up data

Nevada_Data_LONG_2013_2014[,c(25,27:42):=NULL, with=FALSE]
Nevada_Data_LONG_2013_2014[,LAST_NAME:=as.factor(LAST_NAME)]
Nevada_Data_LONG_2013_2014[,FIRST_NAME:=as.factor(FIRST_NAME)]
Nevada_Data_LONG_2013_2014[,GRADE:=as.character(GRADE)]
Nevada_Data_LONG_2013_2014[,SCALE_SCORE:=as.numeric(SCALE_SCORE)]

Nevada_Data_LONG_2013_2014[,GENDER:=factor(GENDER)]
Nevada_Data_LONG_2013_2014[GENDER=="",GENDER:=as.factor(NA)]
Nevada_Data_LONG_2013_2014[,GENDER:=factor(GENDER)]

Nevada_Data_LONG_2013_2014[ETHNICITY=="",ETHNICITY:=as.character(NA)]
Nevada_Data_LONG_2013_2014[,ETHNICITY:=factor(ETHNICITY)]

Nevada_Data_LONG_2013_2014[,FREE_REDUCED_LUNCH_STATUS:=factor(FREE_REDUCED_LUNCH_STATUS)]

Nevada_Data_LONG_2013_2014[,ELL_STATUS:=factor(ELL_STATUS)]

Nevada_Data_LONG_2013_2014[,IEP_STATUS:=factor(IEP_STATUS)]

Nevada_Data_LONG_2013_2014[,GIFTED_AND_TALENTED_PROGRAM_STATUS:=factor(GIFTED_AND_TALENTED_PROGRAM_STATUS)]

Nevada_Data_LONG_2013_2014[,SCHOOL_NAME:=factor(SCHOOL_NAME)]

Nevada_Data_LONG_2013_2014[,EMH_LEVEL:=as.integer(EMH_LEVEL)]
Nevada_Data_LONG_2013_2014[,EMH_LEVEL:=as.factor(EMH_LEVEL)]

Nevada_Data_LONG_2013_2014[,DISTRICT_NAME:=factor(DISTRICT_NAME)]

Nevada_Data_LONG_2013_2014[,SCHOOL_ENROLLMENT_STATUS:=factor(SCHOOL_ENROLLMENT_STATUS)]
Nevada_Data_LONG_2013_2014[,DISTRICT_ENROLLMENT_STATUS:=factor(DISTRICT_ENROLLMENT_STATUS)]
Nevada_Data_LONG_2013_2014[,STATE_ENROLLMENT_STATUS:=factor(STATE_ENROLLMENT_STATUS)]

Nevada_Data_LONG_2013_2014[,ACHIEVEMENT_LEVEL:=factor(ACHIEVEMENT_LEVEL, levels=c("Emergent/Developing", "Approaches Standard", "Meets Standard", "Exceeds Standard"), ordered=TRUE)]


### Merge in EMH_LEVEL

setnames(EMH_LEVELs_2013_2014, "Identifier", "EMH_LEVEL")
EMH_LEVELs_2013_2014[,SCHOOL_NUMBER_3_DIGIT:=NULL]
EMH_LEVELs_2013_2014[,GRADE:=as.character(GRADE)]
EMH_LEVELs_2013_2014[EMH_LEVEL=="E", EMH_LEVEL:="Elementary"]
EMH_LEVELs_2013_2014[EMH_LEVEL=="M", EMH_LEVEL:="Middle"]
EMH_LEVELs_2013_2014[EMH_LEVEL=="H", EMH_LEVEL:="High"]
setkey(EMH_LEVELs_2013_2014, DISTRICT_NUMBER, SCHOOL_NUMBER, GRADE)
setkey(Nevada_Data_LONG_2013_2014, DISTRICT_NUMBER, SCHOOL_NUMBER, GRADE)
Nevada_Data_LONG_2013_2014 <- EMH_LEVELs_2013_2014[Nevada_Data_LONG_2013_2014]
Nevada_Data_LONG_2013_2014[,EMH_LEVEL:=as.factor(EMH_LEVEL)]


### Check for duplicate cases

Nevada_Data_LONG_2013_2014 <- as.data.table(Nevada_Data_LONG_2013_2014)
setkeyv(Nevada_Data_LONG_2013_2014, c("CONTENT_AREA", "YEAR", "ID"))
summary(duplicated(Nevada_Data_LONG_2013_2014))


### Save data

save(Nevada_Data_LONG_2013_2014, file="Data/Nevada_Data_LONG_2013_2014.Rdata")

