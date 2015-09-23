
# Set the working directory

setwd("D:\\My Documents\\Coursera\\Data Scientist\\Getting and Cleaning Data\\Week 3")

# Create data dir if it does not exist

if (!file.exists("data")) {dir.create("data")}

# Download the zip file from the URL

zipfileURL="https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(zipfileURL, "data\\FUCI_dataset.zip", mode="wb")

# Unzip the downloaded file

unzip("data\\FUCI_dataset.zip")

# Read test sets

x_test <- read.table("UCI HAR Dataset\\test\\X_test.txt", header = FALSE)
y_test <- read.table("UCI HAR Dataset\\test\\Y_test.txt", header = FALSE)
subject_test <- read.table("UCI HAR Dataset\\test\\subject_test.txt", header = FALSE)

# Read training sets

x_train <- read.table("UCI HAR Dataset\\train\\X_train.txt", header = FALSE)
y_train <- read.table("UCI HAR Dataset\\train\\Y_train.txt", header = FALSE)
subject_train <- read.table("UCI HAR Dataset\\train\\subject_train.txt", header = FALSE)

# Question 1
#
# Merge the sets

x_merged <- rbind(x_test, x_train)
y_merged <- rbind(y_test, y_train)
subject_merged <- rbind(subject_test, subject_train)

# Question 2
#
# Get the names of the features
# Retrieve the record identifiers, and place them in features_identifiers
# by performing a GREP for the elements of MEAN() or STD() 
# 
# then filter x_merged for these records

features <- read.table("UCI HAR Dataset\\features.txt", header=FALSE, col.names=c("FeatureID", "FeatureName"))
features_identifiers<-grep("mean\\(\\)|std\\(\\)", features$FeatureName)
x_small <- x_merged[, features_identifiers]

# Question 3
#
# Uses descriptive activity names to name the activities in the data set

activity_labels <- read.table("UCI HAR Dataset\\activity_labels.txt", header=FALSE, col.names=c("ActivityID", "ActivityName"))
y_labeled <- merge(y_merged, activity_labels, by.x=names(y_merged)[1], by.y="ActivityID")

# Question 4
#
# Appropriately labels the data set with descriptive variable names.

names(x_small) <- features[features_identifiers, 2]
names(y_labeled)[1] <- c("ActivityID")
names(subject_merged) <- c("Subject")

tidyset <- cbind(subject_merged, y_labeled[2], x_small)

# Question 5
#
# From the data set in step 4, creates a second, independent tidy data set with the 
# average of each variable for each activity and each subject.
#
# Tried to do this using the melt and dcast functions, but this only works for a group of one variable
# therefore I switched to the AGGREGATE() function

tidyset_agg <-aggregate(tidyset[, 3:dim(tidyset)[2]], list(tidyset$Subject, tidyset$ActivityName), mean)

names(tidyset_agg)[1]="Subject"
names(tidyset_agg)[2]="ActivityName"

# Export the file to TXT

write.table(tidyset_agg, file="tidyset_agg.txt", row.names=FALSE)



