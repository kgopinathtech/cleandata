##Create tidy data set from raw data
##Working directory should contain test and train folders and README file for raw data set being transformed

##Load appropriate packages
library(car)

## Read in features 
features<-read.table("features.txt")

##Grep feature names that contain the string "mean"
mvarindices<-grep("mean",as.character(features$V2))
mvars<-as.character(features$V2[mvarindices])

##Grep feature names that contain the string "std"
svarindices<-grep("std",as.character(features$V2))
svars<-as.character(features$V2[svarindices])

##Read training data

##Read training subject ID
sub1<-read.table("./train/subject_train.txt")
names(sub1)<-c("Subject")

##Read activity codes for training subjects and convert to human readable strings

act1<-read.table("./train/y_train.txt")
act1[act1==1]<-"WALKING"
act1[act1==2]<-"WALKING_UPSTAIRS"
act1[act1==3]<-"WALKING_DOWNSTAIRS"
act1[act1==4]<-"SITTING"
act1[act1==5]<-"STANDING"
act1[act1==6]<-"LAYING"
names(act1)<-"Activity"

##Read in Training set
xtrain<-read.table("./train/X_train.txt")

##Read all training set mean values
xtrainmeanvals<-xtrain[mvarindices]
names(xtrainmeanvals)<-mvars

##Read all training set standard deviation values
xtrainstdvals<-xtrain[svarindices]
names(xtrainstdvals)<-svars

## Bind into tidy training data 
tidytrain<-cbind(sub1,act1,xtrainmeanvals,xtrainstdvals)

##Read test data

##Read test subject ID
sub2<-read.table("./test/subject_test.txt")
names(sub2)<-c("Subject")

##Read activity codes for test subjects and convert to human readable strings

act2<-read.table("./test/y_test.txt")
act2[act2==1]<-"WALKING"
act2[act2==2]<-"WALKING_UPSTAIRS"
act2[act2==3]<-"WALKING_DOWNSTAIRS"
act2[act2==4]<-"SITTING"
act2[act2==5]<-"STANDING"
act2[act2==6]<-"LAYING"
names(act2)<-"Activity"

##Read in Test set
xtest<-read.table("./test/X_test.txt")

##Read all Test set mean values
xtestmeanvals<-xtest[mvarindices]
names(xtestmeanvals)<-mvars

##Read all Test set standard deviation values
xteststdvals<-xtest[svarindices]
names(xteststdvals)<-svars

## Bind into tidy test data 
tidytest<-cbind(sub2,act2,xtestmeanvals,xteststdvals)

##Combine training and test data
tidydata<-rbind(tidytrain,tidytest)

finaltidy<-aggregate(tidydata,by=list(tidydata$Subject,tidydata$Activity),FUN=mean)
ft<-subset(finaltidy,select=-c(Subject,Activity))
colnames(ft)[1]<-"Subject"
colnames(ft)[2]<-"Activity"

write.csv(ft,"finaltidydata.csv")

