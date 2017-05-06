#Getting and Cleaning Data Submission
getwd()
#"C:/Users/jeffa/Documents"
setwd("C:/Users/jeffa/Documents")
#Copy and save the source data into this directory


#Read in the test datasets 
testlab<-read.table("~/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/y_test.txt")
test<-read.table("~/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/x_test.txt")
testsub<-read.table("~/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt")
str(testlab) # 2947 observations, 1 variable
str(test) # 2947 observations, 561 variables
str(testsub)# 2947 observations, 1 variable,
#So we need to column bind these together

#Read in the training data 
trainlab<-read.table("~/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/y_train.txt")
train<-read.table("~/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/X_train.txt")
trainsub<-read.table("~/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/subject_train.txt")
str(trainlab)#7352 obs, 1 variable 
str(train) # 7352 obs, 561 variables 
str(trainsub) #7352 obs, 1 variable 

# so we need to stack the test and train datasets

#Combine the activities  - test and train
Activity<-rbind(trainlab,testlab)
names(Activity)<-"activityno"
head(Activity)

# Combine Train and Test data 
data<-rbind(train,test)
str(data)

# Combine the test and train data subjects and give them a suitable name

Person<-rbind(trainsub,testsub)
names(Person)<-"subjectnumber"
str(Person)



# Read in the activity labels and give a suitable name 
Activitylabel<-read.table("~/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/activity_labels.txt")
str(Activitylabel)#6 observations 2 variables, levels 1-6
names(Activitylabel)<-c("activityno","activity")


#Read in variable names
features<-read.table("~/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/features.txt")
str(features) # 561 observations 2 variables - so these correspond with our colimns of the main data

# Apply variable names to the dataset
names(data)<-features[,2]
str(data) #Checked and looks OK but horrible brackets and dashes  - remove shortly


# Extract the means and standard deviations variables only
#I need to remove meanFreq() ones though so select mean and escape character the ()
means<-grep("mean\\()",features[,2])
std<-grep("std",features[,2])
data<-data[,c(means,std)]
names(data)<-gsub("-","_",names(data))
names(data)<-gsub("\\()","",names(data))
str(data)
View(data) # all looks as expected

# Append data to person and activities
data<-cbind(Person,Activity,data)

#Now merge on the activity labels, I want to keep the activity and subjects to the left so will join data to them
#Also  merging is the last thing done as it reorders the data, and I didn't want to do this until the data sas fully joined
data<-merge(Activitylabel,data,by.x="activityno",by.y="activityno", sort=FALSE)
View(data)
#Drop the activity number - not needed 
data<-data[,-1]
View(data)
###### Data set created and looks fine. 

# Now calculate the mean grouped by subject and activity
library(plyr)
library(reshape2)

data.means <- aggregate(data[c(3:68)],by = data[c("subjectnumber","activity")],FUN=mean, na.rm=FALSE)     

View(data.means)

write.table(data.means, file="~/GettingDataAssignment.txt", row.names = FALSE)
