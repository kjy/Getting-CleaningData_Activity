

Summary of run_analysis.R
===============================================================

The run_analysis.R script relies on the zip drive that contains the following data: the `features` data that gives the labels for the predictors, the `activity labels` data that gives the column names for the outcome variable, and 2 additional folders, namely the `train` data set and the `test` data set. Within each of these 2 folders, there are 3 additional data files: the `subject` id participant data, the predictors data `X`, and the outcome data `Y`. A description of the feature selection and their estimates can be found in the `features info` file, which is also in the zip drive.

After downloading and reading in the above data files, I took a look at the NAs in the predictors dataset and saw there were 561 missing observations. I chose to leave these missing obserations in the dataset since I could filter them out later, using the na.omit().

=================================================================

A key step was to merge the data sets across train and test groups. Across each group, the  column dimensions were the same. The training datas set had more observations with 7342 while the test data sets 2947 observations.Binding by row across similar data sets, I ran the following code, where data1 and data4 are the `X` data sets for train and test, each respectively. Similarly data2 and data5 are the `Y` data sets. And finally, data3 and data6 are the `subject` data sets:

```{r}
XX <- rbind(data1,data4,all=TRUE)
YY <- rbind(data2,data5,all=TRUE)
SS <- rbind(data3,data6,all=TRUE)
```

==================================================================

Column names were next added to each of the 3 data sets. Using the `features` data, I extracted the second column to obtain the feature names and assigned it to a vector, which, in turn, was assigned to the column names for the `XX` data. Next, labels were made for both the `YY` data and the `SS` data with the following code:

```{r}
temp <- as.vector(data0[,2]) 
colnames(XX) <- temp 
colnames(YY)[1] <- "Activity"
colnames(SS)[1] <- "Subject"
```
=================================================================

To make a single, full data set, I then proceeded to merge the `XX` predictors data set, `YY` outcome data set and `SS` Subject participant id data set by column binding with the following code:

```{r}
mergeALL <- cbind(XX,YY,SS)
```
=================================================================
To extract only the measurements on the mean and standard deviation for each predictor measurement, I used regular expression, specifcally the grep command to find the indexes of the column names in the merged data set called `mergeALL`. These indexes were combined and sorted and saved in a vector. The Subject and Activity columns along with the predictors that have mean and standard deviation measurements were column bound to a new dataset, called `data2`.

```{r}
tally1 <-grep("mean\\(",colnames(mergeALL))
tally2 <-grep("std\\(",colnames(mergeALL))
totaltally <- c(tally1,tally2)
result <- sort(totaltally)
result <- as.vector(result)
temp0 <- subset(mergeALL,select=c(Subject,Activity),drop=FALSE)
temp1 <- mergeALL[, c(result)]
data2 <- cbind(temp0,temp1)
```
=================================================================
For the outcome variable, I labeled the data with descriptive activity names by changing both the names of the levels and the actual values on the variable, relying on the `activity labels` data that showed the numerical coding of the data that corresponded with the 6 possible activities. 

```{r}
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
```
==================================================================

I then created a second, independent tidy data set with the average of each variable for each activity and each subject, using the `reshape2` package. In this package, the melt function takes data in wide format and stacks a set of columns into a single column of data. This serves the purpose of looking at data first by activity, then by subject. The reverse situation of looking at the data first by subject and then by activity is seen by using the dcast function. For each subject participant 1-30, the output gives  the average of the activity per predictor measurement.

```{r}
molten = melt(na.omit(data2), id.vars=c("Activity", "Subject"))
ActivityData <- dcast(molten, Subject + Activity ~ variable, mean)
```

