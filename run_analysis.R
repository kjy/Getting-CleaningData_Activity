# The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. 
# The goal is to prepare tidy data that can be used for later analysis. 
# You will be graded by your peers on a series of yes/no questions related to the project. 
# You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository 
# with your script for performing the analysis, and 3) a code book that describes the variables, the data, and 
# any transformations or work that you performed to clean up the data called CodeBook.md. You should also include 
# a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.  
# 
# One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained: 
#         
#         http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 
# 
# Here are the data for the project: 
#         
#         https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
# 
# You should create one R script called run_analysis.R that does the following. 
# Merges the training and the test sets to create one data set.
# Extracts only the measurements on the mean and standard deviation for each measurement. 
# Uses descriptive activity names to name the activities in the data set
# Appropriately labels the data set with descriptive activity names. 
# Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

#Read file from Features.txt
setwd("/Users/karenyang/Desktop/UCI_HAR_Dataset")
file0="features.txt"   # Has the labels for the X-variables for both the training and test datasets
data0 <- read.table(file0,header=FALSE)
dim(data0) # 561 x 2


# Read files from train directory
setwd("/Users/karenyang/Desktop/UCI_HAR_Dataset/train")
file1="X_train.txt"
file2="y_train.txt"
file3="subject_train.txt"
data1 <- read.table(file1,header=FALSE)
data2 <- read.table(file2,header=FALSE)
data3 <- read.table(file3,header=FALSE)
dim(data1) # 7352 x 561
dim(data2) # 7352 x 1
dim(data3) # 7352 x 1 


#Read files from test directory
setwd("/Users/karenyang/Desktop/UCI_HAR_Dataset/test")
file4="X_test.txt"
file5="y_test.txt"
file6="subject_test.txt"
data4 <- read.table(file4,header=FALSE)
data5 <- read.table(file5,header=FALSE)
data6 <- read.table(file6,header=FALSE)
dim(data4) # [1] 2947  561
dim(data5) # [1] 2947    1
dim(data6) # [1] 2947    1
sum(is.na(data4)) # [1] 561 # can filter out later with na.omit() so keep

XX <- rbind(data1,data4,all=TRUE)
dim(XX)
YY <- rbind(data2,data5,all=TRUE)
dim(YY)
SS <- rbind(data3,data6,all=TRUE)
dim(SS)

# Make a common primary key for each dataset for merge
# new_vector2 <-c(seq(1:nrow(XX)))
# XX$serial_counter <-new_vector2
# YY$serial_counter <-new_vector2
# SS$serial_counter <-new_vector2

# Add column names to each dataset
temp <- as.vector(data0[,2]) # dataframe with feature names in column 2
length(temp) # [1] 561
colnames(XX) <- temp # assign feature names as column names
colnames(YY)[1] <- "Activity"
colnames(SS)[1] <- "Subject"


# Create merge of X,Y, and subject datasets with column bind
mergeALL <- cbind(XX,YY,SS)
names(mergeALL)


# Extracts only the measurements on the mean and standard deviation for each measurement.
names(mergeALL)
tally1 <-grep("mean\\(",colnames(mergeALL))
tally2 <-grep("std\\(",colnames(mergeALL))
totaltally <- c(tally1,tally2)
result <- sort(totaltally)
result <- as.vector(result)
length(result)
temp0 <- subset(mergeALL,select=c(Subject,Activity),drop=FALSE)
temp1 <- mergeALL[, c(result)]
data2 <- cbind(temp0,temp1)


# Appropriately labels the data set with descriptive activity names. 
data2$Activity[which(data2$Activity==1)]<-"WALKING"
data2$Activity[which(data2$Activity==2)]<-"WALKING_UPSTAIRS"
data2$Activity[which(data2$Activity==3)]<- "WALKING_DOWNSTAIRS"
data2$Activity[which(data2$Activity==4)]<- "SITTING"
data2$Activity[which(data2$Activity==5)]<- "STANDING"
data2$Activity[which(data2$Activity==6)]<- "LAYING"
levels(data2$Activity)[levels(data2$Activity)==1] <- "WALKING"
levels(data2$Activity)[levels(data2$Activity)==2] <- "WALKING_UPSTAIRS"
levels(data2$Activity)[levels(data2$Activity)==3] <- "WALKING_DOWNSTAIRS"
levels(data2$Activity)[levels(data2$Activity)==4] <- "SITTING"
levels(data2$Activity)[levels(data2$Activity)==5] <- "STANDING"
levels(data2$Activity)[levels(data2$Activity)==6] <- "LAYING"


# Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
install.packages("reshape2")
library(reshape2)
#The melt function takes data in wide format and stacks a set of columns into a single column of data. 
molten = melt(na.omit(data2), id.vars=c("Activity", "Subject"))
levels(molten$variable)
dim(molten)
head(molten)
# For each subject 1-30, what is the average of the activity per variable
ActivityData <- dcast(molten, Subject + Activity ~ variable, mean)
str(ActivityData)
ActivityData$Subject
# Write out file for tidy data set
setwd("/Users/karenyang/Desktop/UCI_HAR_Dataset")
#write.table(ActivityData, file = ("tidydata.txt")) # Best to view data in Excel

