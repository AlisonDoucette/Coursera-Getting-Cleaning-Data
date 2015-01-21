### Coursera-Getting-Cleaning-Data: run_analysis.R script.
##### The purpose of the run.analysis.R script is to:
###### 1) Download a zip file of smart phone data from 
###### http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 
###### 2) Process the multiple datasets for variables for test and train data into one Final tidy dataset with complete column headers for the measurement variables and names for the activity type(ex:"Walking" not "1"). 
###### 3) Create an output extract dataset from this tidy dataset which contains calculated means by Activity Type and by Subject.

#### Instructions and interpretations of instructions for Tidy Data Project:

###### You should create one R script called run_analysis.R that does the following. 
##### 1) Merges the training and the test sets to create one data set.
######   Note: This was interpreted as binding together the training and test datasets(each with a different set of subjects).

##### 2) Extracts only the measurements on the mean and standard deviation for each measurement. 
######   Note: This was interpreted as extracting only the columns in the dataset that referenced "mean" or "std".

##### 3) Uses descriptive activity names to name the activities in the data set.
######   This was interpreted as providing names rather than number for activities (ex: "Walking" not "1").

##### 4) Appropriately labels the data set with descriptive variable names.
###### Note This was interpreted as providing column names for the variables from the "Feature.List" dataset.

##### 5) From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
###### Note: This was first interpreted as creating a row of variable averages for each of the Activities and an additional row of variable of averages for each of the Subjects.
###### The resulting output from this assumption is Output1.txt
###### Note: This was secondly interpreted as creating a row of variable averages for each of the Subjects within Activities
###### The resulting output from this assumption is Output2.txt
