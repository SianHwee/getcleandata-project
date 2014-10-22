xxxxxxxxxxxxxxxxxxxxxxx
Step 1
xxxxxxxxxxxxxxxxxxxxxxx

The R script will read the data file in order and merge them into a merged 10299 by 563 data frame
with the rows representing different activities and the columns representing the 561-feature vector with time and frequency domain variables 

The first column of the merged data frame gives the volunteer number

Read x_train.txt and x_test.txt into X
Read y_train.txt and y_test.txt into Y

Merge X and Y into xy
Read subject_train and subject_test into subject_test
Merge subject into xy

xxxxxxxxxxxxxxxxxxxxxxx
Step 2
xxxxxxxxxxxxxxxxxxxxxxx

After the data has been merged, we proceed to extract the only the measurements on the mean and standard deviation for each measurement
The additional vectors obtained by averaging the signals in a signal window sample are excluded from the extracted data. The excluded mean variables are :

gravityMean
tBodyAccMean
tBodyAccJerkMean
tBodyGyroMean
tBodyGyroJerkMean

In addition, the measurements ending with meanfreq() are also excluded by setting fixed=TRUE in the grep function

To determine the columns to be extracted, we first read in the file "features.txt" to create a data frame of all the features included in the 561-vector for each observation
After the features are read in, grep are used to determine the columns numbers that contain either mean() or std() to extract the measurements on the mean and standard deviation for each measurement

features<-read.table("./features.txt", header=FALSE, sep="")
mean_cols<-grep("mean()",features$V2,fixed=TRUE)  #determine the columns that have the mean measurements
stddev_cols<-grep("std()",features$V2,fixed=TRUE)  #determine the columns that have the std dev measurements
req_columns<-c(mean_cols,stddev_cols)  #combine the columns tha contain mean() and std()
req_columns<-req_columns+2   #displace the required coulmns by 2 as the 1st column of merged data frame is subject and 2nd column is the activity code
req_columns<-c(1:2,req_columns) #retain the 1st and 2nd columns of the merged data
ExtractedData<-xy[,req_columns] #extract the data that have the mean() and std() columns

The Extracted data is a 10299 by 68 data frame with the 1st 2 columns being the subject id and activity respectively. The remaining 66 columns are the mean and standard deviation measurements

xxxxxxxxxxxxxxxxxxxxxxxx
Step 3
xxxxxxxxxxxxxxxxxxxxxxxx

We will replace the activity label in the merged data frame with descriptive activity names as follows:

1 walking
2 walkingup
3 walkingdown
4 sitting
5 standing
6 laying


ExtractedData[,2]<-factor(ExtractedData[,2],levels=1:6, labels=c('walking','walkingup','walkingdown','sitting','standing','laying'))

xxxxxxxxxxxxxxxxxxxxxxxx
Step 4
xxxxxxxxxxxxxxxxxxxxxxxx

Using the file "features.txt", we first extract the values of the extracted columns using the grep command with value parameter set to TRUE

meancols<-grep("mean()",features$V2,value=TRUE,fixed=TRUE)  #get column names with mean measurements
stddevcols<-grep("std()",features$V2,value=TRUE,fixed=TRUE) #get column names with standard deviation measurements
colnames<-c(meancols,stddevcols) #merge the 2 column names vectors

The raw names of the extracted column names are as follows :


[1] "tbodyacc-mean()-x"           "tbodyacc-mean()-y"          
 [3] "tbodyacc-mean()-z"           "tgravityacc-mean()-x"       
 [5] "tgravityacc-mean()-y"        "tgravityacc-mean()-z"       
 [7] "tbodyaccjerk-mean()-x"       "tbodyaccjerk-mean()-y"      
 [9] "tbodyaccjerk-mean()-z"       "tbodygyro-mean()-x"         
[11] "tbodygyro-mean()-y"          "tbodygyro-mean()-z"         
[13] "tbodygyrojerk-mean()-x"      "tbodygyrojerk-mean()-y"     
[15] "tbodygyrojerk-mean()-z"      "tbodyaccmag-mean()"         
[17] "tgravityaccmag-mean()"       "tbodyaccjerkmag-mean()"     
[19] "tbodygyromag-mean()"         "tbodygyrojerkmag-mean()"    
[21] "fbodyacc-mean()-x"           "fbodyacc-mean()-y"          
[23] "fbodyacc-mean()-z"           "fbodyaccjerk-mean()-x"      
[25] "fbodyaccjerk-mean()-y"       "fbodyaccjerk-mean()-z"      
[27] "fbodygyro-mean()-x"          "fbodygyro-mean()-y"         
[29] "fbodygyro-mean()-z"          "fbodyaccmag-mean()"         
[31] "fbodybodyaccjerkmag-mean()"  "fbodybodygyromag-mean()"    
[33] "fbodybodygyrojerkmag-mean()" "tbodyacc-std()-x"           
[35] "tbodyacc-std()-y"            "tbodyacc-std()-z"           
[37] "tgravityacc-std()-x"         "tgravityacc-std()-y"        
[39] "tgravityacc-std()-z"         "tbodyaccjerk-std()-x"       
[41] "tbodyaccjerk-std()-y"        "tbodyaccjerk-std()-z"       
[43] "tbodygyro-std()-x"           "tbodygyro-std()-y"          
[45] "tbodygyro-std()-z"           "tbodygyrojerk-std()-x"      
[47] "tbodygyrojerk-std()-y"       "tbodygyrojerk-std()-z"      
[49] "tbodyaccmag-std()"           "tgravityaccmag-std()"       
[51] "tbodyaccjerkmag-std()"       "tbodygyromag-std()"         
[53] "tbodygyrojerkmag-std()"      "fbodyacc-std()-x"           
[55] "fbodyacc-std()-y"            "fbodyacc-std()-z"           
[57] "fbodyaccjerk-std()-x"        "fbodyaccjerk-std()-y"       
[59] "fbodyaccjerk-std()-z"        "fbodygyro-std()-x"          
[61] "fbodygyro-std()-y"           "fbodygyro-std()-z"          
[63] "fbodyaccmag-std()"           "fbodybodyaccjerkmag-std()"  
[65] "fbodybodygyromag-std()"      "fbodybodygyrojerkmag-std()" 

Using gsub command, we rename the columns starting with t***** to time**** and columns starting with f***** to frequency*****
"acc" is also substituted to "acceleration"
"mag" is substituted to "magnitude"
"mean()" is changed to "mean"
"std()" is changed to "stddev"
We also append to the column names the names for the 1st 2 columns, "subjectid" and "activity"

The edited column names are then assigned as the names of the columns of the extracted data in step 2

xxxxxxxxxxxxxxxxxxxxxxxx
Step 5
xxxxxxxxxxxxxxxxxxxxxxxx

We make use of the group_by function dplyr package to group the extracted data by subject and activity
Using summarise_each function in the same package, we then creates a second, independent tidy data set with the average of each variable for each activity and each subject from the group by result

The final tidydata set is a 180 by 68 data frame.

With 30 subjects and 6 activities, the number of observations is 30 x 6 = 180
while the number of columns is retained as we are just summarising the extracted data by taking the average of each extracted measurement.

The final tidydata is output to a output.txt file
