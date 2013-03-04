#####################################################################
###
### Script for producing LONG file
###
#####################################################################

### Load SGP package

require(SGP)


### Load table

Nevada_Data_LONG <- read.table("Data/Base_Files/NDE_Long_File_Growth_With_Gr10_2011_5yrs.txt", sep="|", header=TRUE, comment.char="", quote="")


### Tidy up data

names(Nevada_Data_LONG)[2:3] <- c("STATE_UNIQUE_ID", "LOCAL_UNIQUE_ID")
Nevada_Data_LONG$ID <- as.character(Nevada_Data_LONG$ID)
levels(Nevada_Data_LONG$LAST_NAME) <- sapply(levels(Nevada_Data_LONG$LAST_NAME), capwords)
levels(Nevada_Data_LONG$FIRST_NAME) <- sapply(levels(Nevada_Data_LONG$FIRST_NAME), capwords)
Nevada_Data_LONG$ACHIEVEMENT_LEVEL <- ordered(Nevada_Data_LONG$ACHIEVEMENT_LEVEL, levels=c("Emergent/Developing", "Approaches Standard", "Meets Standard", "Exceeds Standard"))
Nevada_Data_LONG$EMH_LEVEL <- NULL
Nevada_Data_LONG$SCHOOL_ENROLLMENT_STATUS <- as.factor(Nevada_Data_LONG$SCHOOL_ENROLLMENT_STATUS)
levels(Nevada_Data_LONG$SCHOOL_ENROLLMENT_STATUS) <- c("Enrolled School: No", "Enrolled School: Yes")
Nevada_Data_LONG$DISTRICT_ENROLLMENT_STATUS <- as.factor(Nevada_Data_LONG$DISTRICT_ENROLLMENT_STATUS)
levels(Nevada_Data_LONG$DISTRICT_ENROLLMENT_STATUS) <- c("Enrolled District: No", "Enrolled District: Yes")
Nevada_Data_LONG$STATE_ENROLLMENT_STATUS <- as.factor(Nevada_Data_LONG$STATE_ENROLLMENT_STATUS)
levels(Nevada_Data_LONG$STATE_ENROLLMENT_STATUS) <- c("Enrolled State: No", "Enrolled State: Yes")
Nevada_Data_LONG$VALID_CASE <- "VALID_CASE" 


### Check for duplicate cases

Nevada_Data_LONG <- as.data.table(Nevada_Data_LONG)
setkeyv(Nevada_Data_LONG, c("CONTENT_AREA", "YEAR", "ID"))
summary(duplicated(Nevada_Data_LONG))


### Save data

save(Nevada_Data_LONG, file="Data/Nevada_Data_LONG.Rdata")

