#Step 1

x_train<-read.table("./train/X_train.txt", header=FALSE, sep="")
x_test<-read.table("./test/X_test.txt", header=FALSE, sep="")
x<-data.frame() # creates empty data frame to store merged data
x<-rbind(x,x_train) #merge x-train
x<-rbind(x,x_test) #merge x_train
y_train<-read.table("./train/Y_test.txt", header=FALSE, sep="")
y_train<-read.table("./train/Y_train.txt", header=FALSE, sep="")
y<-rbind(y_train,y_test)
xy<-cbind(y,x) #combine x and y data
subject_train<-read.table("./train/subject_train.txt", header=FALSE, sep="")  #read in subject_train
subject_test<-read.table("./test/subject_test.txt", header=FALSE, sep="") #read in subject_test
subject<-rbind(subject_train,subject_test) #merge subject_train and subject_test
xy<-cbind(subject,xy)   #merge subject into comibined dataframe


#Step 2
features<-read.table("./features.txt", header=FALSE, sep="")
mean_cols<-grep("mean()",features$V2,fixed=TRUE)  #determine the columns that have the mean measurements and exclude meanfreq()
stddev_cols<-grep("std()",features$V2,fixed=TRUE)  #determine the columns that have the std dev measurements
req_columns<-c(mean_cols,stddev_cols)  #combine the columns tha contain mean() and std()
req_columns<-req_columns+2   #displace the required coulmns by 2 as the 1st column of merged data frame is subject and 2nd column is the activity code
req_columns<-c(1:2,req_columns) #retain the 1st and 2nd columns of the merged data
ExtractedData<-xy[,req_columns] #extract the data that have the mean() and std() columns

#Step3

# We will replace the activity label in the merged data frame with descriptive activity names as follows:
#   
# 1 walking
# 2 walkingup
# 3 walkingdown
# 4 sitting
# 5 standing
# 6 laying


ExtractedData[,2]<-factor(ExtractedData[,2],levels=1:6, labels=c('walking','walkingup','walkingdown','sitting','standing','laying'))


#Step4

meancols<-grep("mean()",features$V2,value=TRUE,fixed=TRUE)  #get column names with mean measurements
stddevcols<-grep("std()",features$V2,value=TRUE,fixed=TRUE) #get column names with standard deviation measurements
colnames<-c(meancols,stddevcols) #merge the 2 column names vectors
colnames<-tolower(colnames) #convert all column names to lower case

#using gsub to make the column names more meaningful
colnames<-gsub("tbody","timebody",colnames,fixed=TRUE)
colnames<-gsub("tgravity","timegravity",colnames,fixed=TRUE)
colnames<-gsub("fbody","frequencybody",colnames,fixed=TRUE)
colnames<-gsub("bodybody","body",colnames,fixed=TRUE)   # removes duplicated body in some of the column names
colnames<-gsub("fgravity","frequencygravity",colnames,fixed=TRUE)
colnames<-gsub("acc","acceleration",colnames,fixed=TRUE)
colnames<-gsub("mag","magnitude",colnames,fixed=TRUE)
colnames<-gsub("mean()","mean",colnames,fixed=TRUE) #replace mean() with mean
colnames<-gsub("std()","stddev",colnames,fixed=TRUE)
colnames<-c(c("subjectid","activity"),colnames)  #add subject and activity to the column names for 1st 2 columns
names(ExtractedData)<-colnames  #assigned column names to the Extracted data

#Step 5

install.packages("dplyr") #install the dplyr package
library(dplyr)
tidydata<-group_by(ExtractedData,subjectid,activity)  #group by subjectid and activity
tidydata<-summarise_each(tidydata,funs(mean))  #summarise the remaining columns by taking the mean

#tidydata is the final data set to be returned

#write.table(tidaydata,file="./output.txt")  #write to a .txt file























