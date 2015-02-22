# This script is a step by step procedure that transforms the dataset from
# http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 
# into a tidy  dataset as part of Coursera: Getting and Cleaning Data course project

# unzips the file
unzip('getdata-projectfiles-UCI HAR Dataset.zip')

# Loads feature names
features <- read.table('UCI HAR Dataset/features.txt', 
                       header=FALSE, col.names=c('id', 'featureName'), 
                       colClasses = c('numeric', 'character'))

## Step 1 - Merges the training and the test sets to create one data set.

loadData <- function(datatype) {
  data_file <- paste('UCI HAR Dataset/', datatype, '/X_', datatype, '.txt', 
                     sep='')
  label_file <- paste('UCI HAR Dataset/', datatype, '/Y_', datatype, '.txt', 
                      sep='')  
  subject_file <- paste('UCI HAR Dataset/', datatype, '/subject_', datatype, 
                        '.txt', sep='')
  # Load features
  result <- read.table(data_file, header=FALSE, col.names=features$featureName, 
                       colClasses = rep("numeric", nrow(features)))
  # Load labels
  result_label <- read.table(label_file, header=FALSE, col.names=c('label'), 
                             colClasses = c('numeric'))
  # Load subjects
  result_subject <- read.table(subject_file, header=FALSE, 
                               col.names=c('subject'), 
                               colClasses = c('numeric') )
  
  # merge labels and features for data set.
  result$label <- result_label$label
  result$subject <- result_subject$subject
  result  
}

# Load training data set
train <- loadData('train')
test <- loadData('test')

# merge train and test data
alldata <- rbind(train, test)

## Step 2 - Extracts only the measurements on the mean and standard deviation for each measurement. 
requiredFeatures <- grepl("mean\\(\\)",features$featureName) | 
  grepl("std\\(\\)",features$featureName )
requiredCols <- features[requiredFeatures,]$id
requiredData <- alldata[, requiredCols]

# append label and subject since they are required in the final result
requiredData$label <- alldata$label
requiredData$subject <- alldata$subject

## Step 3 - Change to descriptive activity names and variable names. 

# Load activity labels
activity_labels <- read.table('UCI HAR Dataset/activity_labels.txt',
                              header=FALSE, col.names=c('id', 'activity_label'),
                              colClasses = c('numeric', 'character'))

## Step 4  - Join activity labels with the data
requiredData <- merge(requiredData, activity_labels, by.x = 'label', by.y = 'id')

# drop the numeric label column
requiredData <- requiredData[, !(names(requiredData) %in% c('label'))]

## Step 5 - calculate average of each variable for each activity and each subject.
library(reshape2)

meltData <- melt(requiredData, id = c('subject', 'activity_label'))
result <- dcast(meltData, subject + activity_label ~ variable, mean)

# function to add a prefix for the input character
addPrefix <- function(x, prefix) {
  paste(prefix, x, sep="")
}

# creates set of descriptive column names
headerNames <- gsub("\\.+", ".", names(result))
headerNames <- gsub("\\.$", "", headerNames)
headerNames <- sapply(headerNames, addPrefix, "mean.of.")
headerNames[1] <- 'subject'
headerNames[2] <- 'activity'

names(result) <- headerNames

# write the data to a tidy data set as txt file.
write.table(result, "tidy.txt", row.names=FALSE)
