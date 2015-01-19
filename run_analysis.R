## Download zipfile to new working directory
##
setwd("C:/Alison/R/R Working Directory")
## Create directory
##
ProjectDir <- "C:/Alison/R/R Working Directory/Project"
SubDir <-"C:/Alison/R/R Working Directory/Project/ProjectFiles"
library(reshape)
library(dplyr)
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
## 
fileUrl = "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download(fileUrl,dest="C:/Alison/R/R Working Directory/Project/ProjectFiles/dataset.zip")
Filelist <- unzip ("C:/Alison/R/R Working Directory/Project/ProjectFiles/dataset.zip",overwrite=TRUE,list=TRUE,exdir=".")
unzip ("C:/Alison/R/R Working Directory/Project/ProjectFiles/dataset.zip",overwrite=TRUE,exdir="C:/Alison/R/R Working Directory/Project/ProjectFiles/Zipped.Files")
## Read overall datasets into tables (top directory)
##
Dir <- "c:/Alison/R/R Working Directory/Project/ProjectFiles/Zipped.Files/UCI HAR Dataset"
setwd(Dir)
Activity_Levels<-read.table("activity_labels.txt")
colnames(Activity_Levels) <- c("Activity","Activity.Name")
Features<-read.table("features.txt")
Features.Only <-Features[2]
Feature.List <- t(Features.Only)
##Read Test Data filesinto Data Tables
##
TestDir <- "c:/Alison/R/R Working Directory/Project/ProjectFiles/Zipped.Files/UCI HAR Dataset/test"
setwd(TestDir)
## Read X Test Data
##
TestX<-read.table("X_test.txt")
## Set column names on X test to feature list
##
colnames(TestX)<- Feature.List
## Select only the column with names containing "mean" or "std"
Subset.Columns.TestX <-TestX[ , grepl( "mean()|std()" , names( TestX ) ) ]
## Read Y Test Data
##
TestY<-read.table("y_test.txt")
## Set column names for Y Test Data to Activity
colnames(TestY) <- "Activity"
## Read Subject Test Data
##
Subject.Test <- read.table("subject_test.txt")
colnames(Subject.Test) <- "SubjectNum"
##  Join together the columns for the selected variables, the Activities and the Subjects
Test.Data<-cbind(Subset.Columns.TestX,TestY,Subject.Test)
Test.Data2 <-merge(Test.Data, Activity_Levels, by= "Activity")
# Read Training Data into Data Tables - same steps as above for Test Data
##
TrainDir <- "c:/Alison/R/R Working Directory/Project/ProjectFiles/Zipped.Files/UCI HAR Dataset/train"
setwd(TrainDir)
TrainX<-read.table("X_train.txt")
## Set column names on X train to feature list
##
colnames(TrainX)<- Feature.List
## Select only the columns containin the strings :mean or std
##
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
Final.Data2 <- Final.Data[, c(1,82,81,2:80)]
Final.Data3 <- arrange(Final.Data2,Activity,SubjectNum)
## write.table(Final.Data,"C:/Alison/R/R Working Directory/Project/ProjectFiles/Final.Data.txt")
Activity.Means <- aggregate(Final.Data3[,4:82], by=list(Final.Data$Activity.Name), FUN=mean)
Subject.Means <- aggregate(Final.Data3[,4:82], by=list(Final.Data$SubjectNum), FUN=mean)
Activity.Means <- rename(Activity.Means,c('Group.1'='Activity/Subject'))
Subject.Means <- rename(Subject.Means,c('Group.1'='Activity/Subject'))
Output.Data <- rbind(Subject.Means,Activity.Means)
write.table(Output.Data,"C:/Alison/R/R Working Directory/Project/ProjectFiles/Output.Data.txt",row.name=FALSE)
