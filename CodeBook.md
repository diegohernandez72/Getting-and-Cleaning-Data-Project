## The run_analysis.R script has the data and the 5 steps required in the course project's instructions, and is described as follows:

Dataset downloaded from site and unzip under the R folder .data/"UCI HAR Dataset"

#### Reading the data and variable assignment These functions read the metadata and assign it to the variables "features" and "activitylabels"

• **`features`**`<- read.table("UCI HAR Dataset/features.txt.", header = FALSE, sep = "")` *this variable contains 561 rows with the cellphone movement's data from the features.txt file.*

• **`features[,2]`** `<- as.character(features[,2])` *this function transform the second numeric type column of the newly created features variable, as character for further requirement.*

• **`activitylabels`**`<- read.table("UCI HAR Dataset/activity_labels.txt", header = FALSE, sep = "")` *this variable contains data about the 6 subjects activities's from the activity_labels.txt file*

• **`activityLabels[,2]`**`<- as.character(activityLabels[,2])` *this function transform the second numeric type column of the newly created activitiesLabels, as character for further requirement.*

#### These functions read the test data which is in 3 files: X_test(features test), y_test (activities) and subject_test and creates 3 variables with this information:

• **`featurestest`**`<- read.table("UCI HAR Dataset/test/X_test.txt", header = FALSE, sep = "")` *this variable contains the cellphone movement's data from test file. It has 2947 rows, 561 columns.*

• **`activitytest`**`<- read.table("UCI HAR Dataset/test/y_test.txt", header = FALSE, sep = "")` *this variable contains test data of the 6 activities. It has 2947 rows, 1 column.*

• **`subjecttest`**`<- read.table("UCI HAR Dataset/test/subject_test.txt", header = FALSE, sep = "")` *this variable contains test data of 9 of 30 volunteer subjects being tested. It has 2947 rows, 1 column.*

#### These functions read the train data which is in 3 files: X_train (features train), y_train (activities) and subject_train data

• **`featurestrain`**`<- read.table("UCI HAR Dataset/train/X_train.txt", header = FALSE, sep = "")` *this variable contains the cellphone movement's data from train file. It has 7352 rows, 561 columns.*

• **`activitytrain`**`<- read.table("UCI HAR Dataset/train/y_train.txt", header = FALSE, sep = "")` *this variable contains train data of the 6 activities. It has 7352 rows, 1 column.*

• **`subjecttrain`**`<- read.table("UCI HAR Dataset/train/subject_train.txt", header = FALSE, sep = "")` *this variable contains train data of 21 of 30 volunteer subjects being trained. It has 7352 rows, 1 column.*

### 1) Part one - Merge the training and the test sets to create one data set The rbind functions combine the training and the test sets previously created.

• **`subjectcombined`**`<-rbind(subjecttrain, subjecttest)` *creates a data frame where is all the 30 volunteers subject test and train data. It has 10299 rows and 1 column.*

• **`featurescombined`**`<-rbind(featurestrain, featurestest)` *creates a data frame with all features data. It has 10299 rows and 561 columns.*

• **`activitiescombined`**`<-rbind(activitytrain, activitytest)` *creates a data frame with all activity data. It has 10299 rows and 1 column.*

**Naming the columns so that there exist a first row with the appropriate names for each variable**

• **`colnames(featurescombined)`**`<- t(features[2])` *names the variable featurescombined (result of binding X_test an X_train data) with each of the "feature" movement of the 561 columns.*

• **`colnames(activitiescombined)`**`<- "Activity"` *names the variable activitiescombined (result of binding y_test an y_train data) with "Activity" name.*

• **`colnames(subjectcombined)`**`<- "Subject"` *names the variable subjectcombined (result of binding subject\_ test an subject_train data) with "Subject" name.*

**This cbind function merges all data in one data frame**

• **`AllData`**`<- cbind(subjectcombined, activitiescombined, featurescombined)` *creates a DF with the 3 variables and all the data. It contains now 10299 rows with 563 columns.*

### Part 2 - Extracts only the measurements on the mean and standard deviation for each measurement

• **`ColumnDataExtracted`**`<- grep(".mean.|.std.", names(AllData), ignore.case=TRUE)` *using grep function, the columns with only means and standard deviation measurement data are extracted.*

• **`ReqColumns`**`<- c(1, 2, ColumnDataExtracted)` *this function adds Subject and Activity columns to the list, in an object called ReqColumns.*

• **`AllDataExtracted`**`<- AllData[,ReqColumns]` *This functions creates a new DF called AllDataExtracted from AllData rows, and only the extracted columns (ReqColums) with means and standard deviations. It has 10299 rows and 88 columns*

### Part 3 - Uses descriptive activity names to name the activities in the data set

• **`AllDataExtracted`**`$Activity<- factor(AllDataExtracted$Activity, levels= 1:6, labels= activitylabels[,2])` *this functions reassign Activity column in data table with factor labels (from factor levels).*

### Part 4 - Appropriately labels the data set with descriptive variable names

• `names(AllDataExtracted)<-gsub("Acc", "Accelerometer", names(AllDataExtracted))`

• `names(AllDataExtracted)<-gsub("Gyro", "Gyroscope", names(AllDataExtracted))`

• `names(AllDataExtracted)<-gsub("mean", "Mean", names(AllDataExtracted))`

• `names(AllDataExtracted)<-gsub("std", "StandardDeviation", names(AllDataExtracted))`

• `names(AllDataExtracted)<-gsub("BodyBody", "Body", names(AllDataExtracted)) 2`

• `names(AllDataExtracted)<-gsub("Mag", "Magnitude", names(AllDataExtracted))`

• `names(AllDataExtracted)<-gsub("ˆt", "Time", names(AllDataExtracted))`

• `names(AllDataExtracted)<-gsub("ˆf", "Function", names(AllDataExtracted))`

• `names(AllDataExtracted)<-gsub("AccJerk", "AngularAcceleration", names(AllDataExtracted))`

• `names(AllDataExtracted)<-gsub("Freq", "Frequency", names(AllDataExtracted))`

• `names(AllDataExtracted)<-gsub("gravity", "Gravity", names(AllDataExtracted))`

• `names(AllDataExtracted)<-gsub("tBody", "TimeBody", names(AllDataExtracted))`

• `names(AllDataExtracted)<-gsub("angle", "Angle", names(AllDataExtracted))`

• `names(AllDataExtracted)<-gsub(" "," ", names(AllDataExtracted))`

• `names(AllDataExtracted)<-gsub("-", " ", names(AllDataExtracted))`

• `names(AllDataExtracted)<-gsub(" "," ", names(AllDataExtracted))`

### Part 5 - From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject

• `TidyData<- AllDataExtracted %>% group_by(Subject, Activity) %>% summarize_all(funs(mean))`*TidyData represents de final DT with the mean of each variable grouped by Subject and Activity. It contains 180 rows and 88 columns.*

• `write.table(TidyData, file = "TidyData.txt", row.name=FALSE`) *A DT text file was finally created.*
