
# Merges the training and the test sets to create one data set.
# Extracts only the measurements on the mean and standard deviation for each measurement.
# Uses descriptive activity names to name the activities in the data set
# Appropriately labels the data set with descriptive variable names.
# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# Find all of the pertinate files
testfiles <- list.files("./UCI HAR Dataset/test")
trainfiles <- list.files("./UCI HAR Dataset/train")

#Remove from the files lists the name of the Inertial Signals subfolder
testfiles <- testfiles[2:4]
trainfiles <- trainfiles[2:4]

activitylabels <- read.table("./UCI HAR Dataset/activity_labels.txt", header = FALSE)
features <- read.table("./UCI HAR Dataset/features.txt", header = FALSE)

#Test Data
#
#read the subject labels
subjecttest <- read.table("./UCI HAR Dataset/test/subject_test.txt", header = FALSE)
subjecttest <- rename(subjecttest,subject=V1)
#read the data
xtest <- read.table("./UCI HAR Dataset/test/X_test.txt", header = FALSE)
names(xtest) <- features[,2]
#read the activity descriptions
ytest <- read.table("./UCI HAR Dataset/test/y_test.txt", header = FALSE)
ytest <- rename(ytest,activity=V1)
#match the activity number to the actual text description
ytest[,1] <- activitylabels[,2][match(ytest[,1],activitylabels[,1])]

#Combine all of the 'test' data into one table
testdata <- cbind(subjecttest,ytest,xtest)

#Train data
#
#read the subject labels
subjecttrain <- read.table("./UCI HAR Dataset/train/subject_train.txt", header = FALSE)
subjecttrain <- rename(subjecttrain,subject=V1)
#read the data
xtrain <- read.table("./UCI HAR Dataset/train/X_train.txt", header = FALSE)
names(xtrain) <- features[,2]
#read the activity descriptions
ytrain <- read.table("./UCI HAR Dataset/train/y_train.txt", header = FALSE)
ytrain <- rename(ytrain,activity=V1)
#match the activity number to the actual text description
ytrain[,1] <- activitylabels[,2][match(ytrain[,1],activitylabels[,1])]

#Combine all of the 'train' data into one table
traindata <- cbind(subjecttrain,ytrain,xtrain)

#Combine 'test' and 'train' datasets into wholedata
wholedata <- rbind(testdata,traindata)

#Find all of the indices for the 'mean' and 'std' variables we care about
variablesofinterest <- grep("[Mm]ean|std",names(wholedata))
variablesofinterest <- c(1,2,variablesofinterest)
#Subset the 'wholedata' to be only the stuff we care about
wholedata <- wholedata[,variablesofinterest]

#make subject and activity variables factors
wholedata$subject <- as.factor(wholedata$subject)
wholedata$activity <- as.factor(wholedata$activity)

#melt the data by 'subject' and 'activity' and the 86 variables of interest
meltdata <- melt(wholedata,id=1:2,measure.vars=3:88)

#Recast the data so that each combination of subject*activity has average values
castdata <- dcast(meltdata,subject+activity~variable, mean)
write.table(castdata, file="tylerupload.txt",row.name=FALSE)

