dir_Project = "./Project"
if(!file.exists(dir_Project)) {dir.create(dir_Project)}						#checks for directory
FileUrl = "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip" 
																			#url as http due to windows version of R having issues with https
destFile = paste(dir_Project, "data.zip", sep="/")							#places zip in directiry
download.file(FileUrl, destfile=destFile)		    						#downloads file and places in directory Project
unzip(destFile, exdir=dir_Project)											#unzips files into directory Project

#set the required directories
dir_Data = paste(dir_Project, "UCI HAR Dataset", sep="/")					#creates subfolders
dir_Train = paste(dir_Data, "train", sep="/")
dir_Test = paste(dir_Data, "test", sep="/")

#reading and filtering features (only "mean" and "std" features)
file = paste(dir_Data, "features.txt", sep="/")								#loads up features file
features <- read.table(file, sep=" ")										#reads features seperating on the space character
index_extracted_features <- (grepl("mean\\(\\)", features[,2]) | grepl("std\\(\\)", features[,2]))
																			#filters features using grepl looking for characters that contain mean
																			#or std deviation 
names_extracted_features <- as.character(features[index_extracted_features,2])	#pulls second column containing field names
	
																			#reading in the training files and combining them using cbind
widthCols = (2*as.numeric(index_extracted_features)-1)*16					#assigned neg value and hence length to fields not pulled in grepl
file = paste(dirTrain, "X_train.txt", sep="/")
X_train <- read.fwf(file, width=widthCols, sep="", comment.char="", colClasses="numeric")	#skips columns with neg width
file = paste(dir_Train, "y_train.txt", sep="/")								#1x7353 table
y_train <- read.table(file)													#files pulling from directory dir_Train
file = paste(dir_Train, "subject_train.txt", sep="/")
subject_train <- read.table(file)											#similar setup to y_train
train_data <- cbind(X_train, y_train, subject_train)						#all the same # of records so no worries about recycling
																			#same as above except these are pulling from the dir_Test directory

file = paste(dir_Test, "X_test.txt", sep="/")
X_test <- read.fwf(file, width=widthCols, sep="", comment.char="", colClasses="numeric")
file = paste(dir_Test, "y_test.txt", sep="/")
Y_test <- read.table(file)						
file = paste(dir_Test, "subject_test.txt", sep="/")
subject_test <- read.table(file)
test_data <- cbind(X_test, y_test, subject_test)

																			#merge test and train datasets
all_data <- rbind(train_data, test_data)
colnames(all_data) <- c(names_extracted_features, c("activity", "subject"))  	#sets column names to values gathered from 
																			#adds label and subject to be used later
#create a data set with the average of each variable for each activity and each subject

all_average <- aggregate(all_data[,1:66], by=list(all_data$activity,all_data$subject), FUN = "mean")
colnames(all_average)[1:2] = c("activity","subject")

																			#Write files to disk as csv
file = paste(dir_Data, "all_data.txt", sep="/")
write.csv(all_data, file, row.names=FALSE)
file = paste(dir_Data, "all_average.txt", sep="/")
write.csv(all_average, file, row.names=FALSE)
