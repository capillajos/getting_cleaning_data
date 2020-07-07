## Downloading file to local folder

zipfile <- "C:/Users/h247206/Documents/Cursos/3 Getting and Cleaning Data/getting_cleaning_data/getdata_projectfiles_UCI HAR Dataset.zip"
enlace <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

## Test if file exists and download/unzip

if (!file.exists(zipfile)){
    download.file(enlace, zipfile,method = curl)
  }

if (!file.exists("UCI HAR Dataset")){
  unzip(zipfile)
}

## read tables

features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("activity_code", "activity"))
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "activity_code")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "activity_code")

## 1. Merge data

X <- rbind(x_train, x_test)
Y <- rbind(y_train, y_test)
Subjects <- rbind(subject_train, subject_test)
Data <- cbind(Subjects, Y, X)

## 2. Extracts only the measurements on the mean and standard deviation for each measurement.

library(dplyr)

library(tidyr)
Data <- Data %>% select(subject, activity_code, contains("mean"), contains("std"))


## 3. Uses descriptive activity names to name the activities in the data set.

Data$activity_code <- activities[Data$activity_code, 2]

## 4. Appropriately labels the data set with descriptive variable names.

names(Data)[1] = "Subject"
names(Data)[2] = "Activity"

names(Data)<-gsub("Acc", "Accelerometer", names(Data))
names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
names(Data)<-gsub("^t", "Time", names(Data))
names(Data)<-gsub("^f", "Frequency", names(Data))
names(Data)<-gsub("gravity", "Gravity", names(Data))
names(Data)<-gsub("BodyBody", "Body", names(Data))
names(Data)<-gsub("Mag", "Magnitude", names(Data))
names(Data)<-gsub("tBody", "TimeBody", names(Data))
names(Data)<-gsub("-mean()", "Mean", names(Data), ignore.case = TRUE)
names(Data)<-gsub("-std()", "STD", names(Data), ignore.case = TRUE)
names(Data)<-gsub("-freq()", "Frequency", names(Data), ignore.case = TRUE)
names(Data)<-gsub("angle", "Angle", names(Data))

## 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

New_Data <- group_by(Data, Subject, Activity)
New_Data <- summarise_all(New_Data, mean)
write.table(New_Data, "New_Data.txt", row.name=FALSE)

