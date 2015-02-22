CODE BOOK

This is a code book that describes the variables, the data, and  transformations that I performed to clean up the data.

ABOUT THE DATA SOURCE 

There original data comes from the smartphone accelerometer and gyroscope 3-axial raw signals, which have been processed using various signal processing techniques to measurement vector consisting of 561 features. Links to orignal data and descirptions below

Original data: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
Original description of the dataset: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

ABOUT THE TIDY DATA SET

* The tidy data set contains the mean and standard deviations values for each subject and activity
* The data set is stored as a txt file that uses a single space as the delimiter.
* The first line ofthe data contains the variable name of the data which are contained in double quotes '"'.

ABOUT THE VARIABLES

subject - the subject is who performed the activity for each window sample. values range from  1 to 30. 
activity - the activity identifies a specific activity that the subject performed. There are 6 different types of activities, including "WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING", and "LAYING"

all other variables are measurement collected from the accelerometer and gyroscope 3-axial raw signal.

variable names using the following naming convention:
  -All variable names start with measurement name 
  -All variable names end with a suffix of either  "-mean" or "-std" followed by a ".X" or ".Y" or ".Z", which indicates the measurement direction of a 3-axial singals.  
  -If varaiable nam starts with a prefix of 't', this denotes time domain signals captured at a constant rate of 50 Hz.
  -If variable name starts with a prefix of 'f', this denotes frequency domain signals, which were applied by a Fast Fourier Transform (FFT) of the original signal.

TRANSFORMATION DETAILS

-Unzip the zip file, "UCI HAR Dataset" directory contains all the data required.
-Merged the X_train.txt, y_train.txt, subject_train.txt to a single train data set, using features.txt as the column names of the merged data.
-Merged the X_test.txt, y_test.txt, subject_test.txt to a single test data set, using features.txt as the column names of the merged data.
-Appends test data set to train data set
-Keep only columns which contains necessary measurements,  mean() or std() 
-Join the full data set with the activity_labels.txt by label id comes from y_train.txt and y_test.txt to get the activity name.
-Drop label id.
-Using reshape2 lib, to melt and dcast method to get the mean of all variables for each subject and each activity as the result dataset.
-Reset the dataset column names with a "mean.of" prefix
-Write the result dataset to local file system.