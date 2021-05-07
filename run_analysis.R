
#downloaded the data from the site
fileURL<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileURL, destfile = "./data/Dataset.zip", method = "curl")

# unzip de file and store in the folder
unzip(zipfile="./data/Dataset.zip",exdir="./data")



#Libraries used
library(dplyr)
library(data.table)


#read the metadata (features and activity labels)
features<- read.table("UCI HAR Dataset/features.txt", header = FALSE, sep = "")
features[,2] <- as.character(features[,2])
activitylabels<- read.table("UCI HAR Dataset/activity_labels.txt", header = FALSE, sep = "")
activitylabels[,2] <- as.character(activitylabels[,2]) 

#read the test data which is in 3 files: X_test(features test), y_test (activities) and subject_test
featurestest<- read.table("UCI HAR Dataset/test/X_test.txt", header = FALSE, sep = "")
activitytest<- read.table("UCI HAR Dataset/test/y_test.txt", header = FALSE, sep = "")
subjecttest<- read.table("UCI HAR Dataset/test/subject_test.txt", header = FALSE, sep = "")

#read the train data which is in 3 files: X_train (features train), y_train (activities) and subject_train data  
featurestrain<- read.table("UCI HAR Dataset/train/X_train.txt", header = FALSE, sep = "")
activitytrain<- read.table("UCI HAR Dataset/train/y_train.txt", header = FALSE, sep = "")
subjecttrain<- read.table("UCI HAR Dataset/train/subject_train.txt", header = FALSE, sep = "")

#1) Part one - Merge the training and the test sets to create one data set
#Combine the training and the test sets 
subjectcombined<-rbind(subjecttrain, subjecttest) #creates a data frame with subject data
featurescombined<-rbind(featurestrain, featurestest) #creates a data frame with all features data 
activitiescombined<-rbind(activitytrain, activitytest) #creates a data frame with all activity data 


#Naming the columns

colnames(featurescombined) <- t(features[2])
colnames(activitiescombined) <- "Activity"
colnames(subjectcombined) <- "Subject"

#merged all data in one data frame
AllData <- cbind(subjectcombined, activitiescombined, featurescombined)

#Part 2 - Extracts only the measurements on the mean and standard deviation for each measurement
ColumnDataExtracted <- grep(".*Mean.*|.*Std.*", names(AllData), ignore.case=TRUE)# using grep function, are extracted the columns with data of means and standard deviation 
ReqColumns <- c(1, 2, ColumnDataExtracted)# this function adds Subject and Activity columns to the list, in an object called RequiredColumns
AllDataExtracted <- AllData[,ReqColumns]# This functions creates a new DF called ExtractedData from AllData rows, and only the extracted columns (RequiredColums) with means and standard deviations. It has 10299 rows and 88 columns

#Part 3 - Uses descriptive activity names to name the activities in the data set
AllDataExtracted$Activity <- factor(AllDataExtracted$Activity, levels= 1:6, labels= activitylabels[,2]) #this functions reassign Activity column in data table with factor labels (from factor levels)

#Part 4 - Appropriately labels the data set with descriptive variable names

names(AllDataExtracted)<-gsub("Acc", "Accelerometer", names(AllDataExtracted))
names(AllDataExtracted)<-gsub("Gyro", "Gyroscope", names(AllDataExtracted))
names(AllDataExtracted)<-gsub("mean", "Mean", names(AllDataExtracted))                 
names(AllDataExtracted)<-gsub("std", "StandardDeviation", names(AllDataExtracted))
names(AllDataExtracted)<-gsub("BodyBody", "Body", names(AllDataExtracted))
names(AllDataExtracted)<-gsub("Mag", "Magnitude", names(AllDataExtracted))
names(AllDataExtracted)<-gsub("^t", "Time", names(AllDataExtracted)) 
names(AllDataExtracted)<-gsub("^f", "Function", names(AllDataExtracted)) 
names(AllDataExtracted)<-gsub("AccJerk", "AngularAcceleration", names(AllDataExtracted))
names(AllDataExtracted)<-gsub("Freq", "Frequency", names(AllDataExtracted))
names(AllDataExtracted)<-gsub("gravity", "Gravity", names(AllDataExtracted))
names(AllDataExtracted)<-gsub("tBody", "TimeBody", names(AllDataExtracted))
names(AllDataExtracted)<-gsub("angle", "Angle", names(AllDataExtracted))
names(AllDataExtracted)<-gsub("  "," ", names(AllDataExtracted)) 
names(AllDataExtracted)<-gsub("-", " ", names(AllDataExtracted)) 
names(AllDataExtracted)<-gsub("  "," ", names(AllDataExtracted)) 

#Part 5 - From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject
TidyData <- AllDataExtracted %>% group_by(Subject, Activity) %>% summarize_all(funs(mean))
write.table(TidyData, file = "TidyData.txt", row.name=FALSE)

             