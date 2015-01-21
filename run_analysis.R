##  This script does the following:
##  1) Creates Project Directories
##  2) Downloads a zip file to the new Project Directory
##  3) Reads in files and creates data tables
##  4) Selects specifif colunns (Mean and STD) from Test and Train data tables
##  5) Stitches together colunn headers from a measurement variables (Features) names table
##  6) Stitches together Subject data and observational data
##  7) Looks up Activity Names in Activity Data table
##  8) Joins together the "stitched" Test and Train tables into a "Tidy Dataset'
##  9) Inteprets the instructions as one row per activity and one row per subject 
##  9) Calculates the means by Subject
##  10) Calculates the means by Activity
##  11) Stitches together the means files
##  12) Inteprets the instructions as one row per activity and one row per subject
##  12) Write the means files out to an external data table - Output.Data1
##  13) Inteprets the instructions as one row per Activity/Subject Combination 
##  14) Aggregates the means by Activity and then Subject
##  15) Write the means files out to an external data table - Output.Data2
##  16) Aggregates the means by Subject and then Activity
##  17) Write the means files out to an external data table - Output.Data3
## Load Libraries
library(reshape)
library(plyr) 
library(dplyr)
library(downloader)
Download zipfile to brand-new working directory
##
setwd("C:/Alison/R/R Working Directory")
## Create Project Directories
##
    ProjectDir <- "C:/Alison/R/R Working Directory/Project"
    SubDir <-"C:/Alison/R/R Working Directory/Project/ProjectFiles"
    if (file.exists(ProjectDir)){
        setwd(file.path(ProjectDir))
    } else {
        dir.create(file.path(ProjectDir))
        setwd(file.path(ProjectDir))
    }
##  Create Directory for files
    if (!file.exists("ProjectFiles")) {
        dir.create("ProjectFiles")
    }
library(downloader)
## Set R Studio Settings for download
##
    setInternet2(use=TRUE)
## Download the zip file from the internet and unzip the file

    fileUrl = "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download(fileUrl,dest="C:/Alison/R/R Working Directory/Project/ProjectFiles/dataset.zip")
    Filelist <- unzip ("C:/Alison/R/R Working Directory/Project/ProjectFiles/dataset.zip",overwrite=TRUE,list=TRUE,exdir=".")
    unzip ("C:/Alison/R/R Working Directory/Project/ProjectFiles/dataset.zip",overwrite=TRUE,exdir="C:/Alison/R/R Working Directory/Project/ProjectFiles/Zipped.Files")
## Read overall datasets into tables (top directory)

    Dir <- "c:/Alison/R/R Working Directory/Project/ProjectFiles/Zipped.Files/UCI HAR Dataset"
    setwd(Dir)
    Activity_Levels<-read.table("activity_labels.txt")
    colnames(Activity_Levels) <- c("Activity","Activity.Name")
    Features<-read.table("features.txt")
    Features.Only <-Features[2]
    Feature.List <- t(Features.Only)
##Read Test Data filesinto Data Tables

    TestDir <- "c:/Alison/R/R Working Directory/Project/ProjectFiles/Zipped.Files/UCI HAR Dataset/test"
    setwd(TestDir)
## Read X Test Data

   TestX<-read.table("X_test.txt")
## Set column names on X test to feature list

    colnames(TestX)<- Feature.List
## Select only the column with names containing "mean" or "std"
Subset.Columns.TestX <-TestX[ , grepl( "mean()|std()" , names( TestX ) ) ]
## Read Y Test Data

TestY<-read.table("y_test.txt")
## Set column names for Y Test Data to Activity
    colnames(TestY) <- "Activity"
## Read Subject Test Data

    Subject.Test <- read.table("subject_test.txt")
    colnames(Subject.Test) <- "SubjectNum"
##  Join together the columns for the selected variables, the Activities and the Subjects
    Test.Data<-cbind(Subset.Columns.TestX,TestY,Subject.Test)
    Test.Data2 <-merge(Test.Data, Activity_Levels, by= "Activity")
# Read Training Data into Data Tables - same steps as above for Test Data

    TrainDir <- "c:/Alison/R/R Working Directory/Project/ProjectFiles/Zipped.Files/UCI HAR Dataset/train"
    setwd(TrainDir)
    TrainX<-read.table("X_train.txt")
## Set column names on X train to feature list

    colnames(TrainX)<- Feature.List
## Select only the columns containin the strings :mean or std

    Subset.Columns.TrainX <-TrainX[ , grepl( "mean()|std()" , names( TrainX ) ) ]
## Read Y train Data
    TrainY<-read.table("y_train.txt")
    colnames(TrainY) <- "Activity"
## Read Subject Train Data
    Subject.Train <- read.table("subject_train.txt")
    colnames(Subject.Train) <- "SubjectNum"
##  Join together the columns for the selected variables, the Activities and the Subjects
    Train.Data<-cbind(Subset.Columns.TrainX,TrainY,Subject.Train)
    Train.Data2 <-merge(Train.Data, Activity_Levels, by= "Activity")
    Final.Data<-rbind(Test.Data2,Train.Data2)
## reorder columns in Final Data - This is the "Tidy Data #1"
    Final.Data2 <- Final.Data[, c(1,82,81,2:80)]
    Final.Data3 <- arrange(Final.Data2,Activity,SubjectNum)
## Calculate Means for Activity and for Subjects
    Activity.Means <- aggregate(Final.Data3[,4:82], by=list(Final.Data$Activity.Name, Final.Data$SubjectNum), FUN=mean)
library(plyr)
    Subject.Means <- aggregate(Final.Data3[,4:82], by=list(Final.Data$SubjectNum), FUN=mean)
    Subject.Means <- rename(Subject.Means,c("Group.1"="Activity/Subject"))
    Activity.Means <- rename(Activity.Means,c("Group.1"="Activity/Subject"))
## Join together Activity Means file and Subject Means File - Note - not Subject with Activity as instructions do not say "within"
    Output.Data <- rbind(Subject.Means,Activity.Means)
## Write Output Data Table - Interpretation #1 - 1 row for each Activity Means and 1 row for each Subject Means
    write.table(Output.Data,"C:/Alison/R/R Working Directory/Project/ProjectFiles/Output.Data1.txt",row.name=FALSE)
## Write Output Data Table - Interpretation #2 - 1 row for each Activity/Subject Means
    Output.Data2 <- aggregate(Final.Data3[,4:82], by=list(Final.Data$Activity.Name, Final.Data$SubjectNum), FUN=mean)
    Output.Data2 <- rename(Output.Data2,c("Group.1"="Activity",Group.2="Subject"))
    Output.Data2 <- Output.Data2[with(Output.Data2, order(Output.Data2$Activity, Output.Data2$Subject)),]
    write.table(Output.Data2,"C:/Alison/R/R Working Directory/Project/ProjectFiles/Output.Data2.txt",row.name=FALSE)
## Write Output Data Table - Interpretation #3 - 1 row for each Activity/Subject Means
    Output.Data3 <- aggregate(Final.Data3[,4:82], by=list(Final.Data$SubjectNum, Final.Data$Activity.Name), FUN=mean)
    Output.Data3 <- rename(Output.Data3,c("Group.1"="Subject",Group.2="Activity"))
    Output.Data3 <- Output.Data3[with(Output.Data3, order(Output.Data3$Subject, Output.Data3$Activity)),]
    write.table(Output.Data3,"C:/Alison/R/R Working Directory/Project/ProjectFiles/Output.Data3.txt",row.name=FALSE)