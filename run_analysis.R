# Loading packages and getting the data
library(data.table)
library(reshape2)
path<-getwd()
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",file.path(path,"data.zip"))
unzip(zipfile = "data.zip")

#Loading activity labels and features
activitylabels<-fread(file.path(path,"UCI HAR Dataset/activity_labels.txt"),col.names=c("classLabels","activityName"))
features<-fread(file.path(path,"UCI HAR Dataset/Features.txt"),col.names = c("index","featureNames"))
wantedFeatures<-grep("(mean|std)\\(\\)",features[,featureNames])
measurement<-features[wantedFeatures,featureNames]
measurement<-gsub('[()]','',measurement)

#Loading Train datasets
train<-fread(file.path(path,"UCI HAR Dataset/train/X_train.txt"))[,wantedFeatures,with=FALSE]
data.table::setnames(train,colnames(train),measurement)
activities_train<-fread(file.path(path,"UCI HAR Dataset/train/Y_train.txt"),col.names = c("activity"))
subjects_train<-fread(file.path(path,"UCI HAR Dataset/train/subject_train.txt"),col.names = c("subjectNumber"))
train<-cbind(subjects_train,activities_train,train)

#Loading Test datasets
test<-fread(file.path(path,"UCI HAR Dataset/test/X_test.txt"))[,wantedFeatures,with=FALSE]
data.table::setnames(test,colnames(test),measurement)
activities_test<-fread(file.path(path,"UCI HAR Dataset/test/Y_test.txt"),col.names = c("activity"))
subjects_test<-fread(file.path(path,"UCI HAR Dataset/test/subject_test.txt"),col.names=c("subjectNumber"))
test<-cbind(subjects_test,activities_test,test)

#merging datasets
merged<-rbind(train,test)

merged[["activity"]]<-factor(merged[,activity],levels = activitylabels[["classLabels"]],labels=activitylabels[["activityName"]])
merged[["subjectNumber"]]<-as.factor(merged[,subjectNumber])
merged<-reshape2::melt(data=merged,id=c("subjectNumber","activity"))
merged<-reshape2::dcast(data = merged,subjectNumber+activity~variable,fun.aggregate = mean)

data.table::fwrite(x=merged,file="tidyData.txt",quote = FALSE)