setwd("~/GitHub/Getting-and-Cleaning-Data") 
#Set working directory


library(dplyr)
library(reshape2)
# Library call for the dplyr package, which is used for data manipulation
# Library call for the tidyr package, which is used to clean the data

if(!file.exists("run_analysis_data.zip")) {dir.create("./Getting-and-Cleaning-Data")}
fileUrl <- download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile = "run_analysis_data.zip", method = "curl")
# Downloads the file, names it, and places it in working directory

unzip("run_analysis_data.zip")
# Unzips the downloaded file. Every file that follows comes from the unzipped file.

features <- read.table("UCI HAR Dataset/features.txt")
# Stores the names for the variables in the variable "features."
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")
# Stores the names for each activity in the variable "activity_labels"
colnames(activity_labels) <- c("Activities", "Activity Labels")


test_data <- read.table("UCI HAR Dataset/test/X_test.txt") 
# Stores test data
colnames(test_data) <- features["V2"] 
# Adds labels to the columns for test data
test_activities <- read.table("UCI HAR Dataset/test/y_test.txt") 
# Adds test activity numbers
colnames(test_activities) <- "Activities" 
# Adds label "Activities" to activity numbers
test_subject <- read.table("UCI HAR Dataset/test/subject_test.txt") 
# Stores test Subject ID numbers
colnames(test_subject) <- "Subject_ID" 
# Adds label "Subject_ID" to Subject ID numbers
test <- bind_cols(test_subject, test_activities, test_data) 
# Binds all three columns of data in the following order


train_data <- read.table("UCI HAR Dataset/train/X_train.txt") 
# Stores train data
colnames(train_data) <- features["V2"] 
# Adds labels to the columns for train data
train_activities <- read.table("UCI HAR Dataset/train/y_train.txt") 
# Add train activity numbers
colnames(train_activities) <- "Activities" 
# Adds label "Activities" to activity numbers
train_subject <- read.table("UCI HAR Dataset/train/subject_train.txt") 
# Stores train Subject ID numbers
colnames(train_subject) <- "Subject_ID" 
# Adds label "Subject_ID" to Subject ID numbers
train <- bind_cols(train_subject, train_activities, train_data) 
# Binds all thress columns of data in the following order




total_data <-bind_rows(test, train)
# Binds the train and test data and stores it in the variable "total_data"

total_data$Activities <- activity_labels[total_data$Activities, "Activity Labels"]
# Takes activity numbers and matches them with appropriate Activity Labels



mean_std_data <-select(total_data, Subject_ID, Activities, contains("mean"), contains("std")) %>%
  # Selects the columns Subject_ID, Activities and all variables that contain the words mean an std
  # This gives us the variables with mean and standard deviation
  arrange(Subject_ID, Activities)
  # Arranges the columns in order first by Subject ID, then by Activity
mean_std_data <- tbl_df(mean_std_data)
  # Stores mean_std_data as a data frame
View(mean_std_data)
  # Command to view final data frame, which was stored in the variable mean_std_data
  # Data was chained together using the dplyr package
mean_melt <- melt(mean_std_data, id=c("Subject_ID", "Activities"))
  # Subject_ID and Activities are stored as ID variables and Data is reshaped
averages <- dcast(mean_melt, Subject_ID + Activities ~ variable, mean)
  # The melted data frame has the mean of each variable taken by Subject ID and Variable
averages <- tbl_df(averages)
  # Stores averages as a data frame
View(averages)
  # Command to view data set that contains the mean for each variable telling how each subject did on each activity

write.table(averages, file="Averages.txt", row.names = FALSE)
  # Turns the final data set into a text file
