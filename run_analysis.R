#Required libraries

library(stringr)

#The data are under the "test" and "train" subfolders of the workspace
#The common "features" and "activity_labels" files are in the workspace

#First load subject data
subjects <- rbind(read.table("./test/subject_test.txt"), read.table("./train/subject_train.txt"))

#Load activities data
activity_numbers <- rbind(read.table("./test/y_test.txt"), read.table("./train/y_train.txt"))

#Load activity labels
#The first col is ignored (only an index)
activity_labels <- as.vector(read.table("./activity_labels.txt")[,2])

#Replace activity numbers by labels, in a new string vector
n <- nrow(activity_numbers)

activities <- vector()

for (i in 1:n) { 
    
  activities <- rbind(activities, activity_labels[activity_numbers[i,1]])
  
}

#Load features data
features <- rbind(read.table("./test/X_test.txt"), read.table("./train/X_train.txt"))

#Load names for features and labels for activities
#Convert features_names to a vector (it is of class factor)
features_names <- as.vector(read.table("./features.txt")[,2])

#Now assembling the result table

#First subjects and activities (labels)
result_table <- cbind(subjects, activities)

#Set the names of the first 2 columns
names(result_table)[1] <- "subject"
names(result_table)[2] <- "activity"

#Then the mean and std features only, from the features table 

#Index to set the names of the selected columns, starting from col 3
index <- 3

n <- ncol(features)

for (i in 1:n) {
  
  a_feature_name <- features_names[i]
  
  #Selecting with str_locate() only the columns which name contains the string "mean" or "std"
  if (!is.na(str_locate(a_feature_name,"mean|std")[1])) {
    
    #Adding the feature data and its name to the result table
    result_table <- cbind(result_table, features[,i])
    
    names(result_table)[index] <- a_feature_name
    
    index <- index + 1
  }
}

#Last step, new data set for the average of each variable for each activity and each subject

#We use the aggregate function
by_subject <- result_table[,1]
by_activity <- result_table[,2]

#We exclude the first 2 columns (grouping columns)
averages_table <- aggregate(result_table[,3:81], list(by_activity, by_subject), mean)

#Returns 180 rows (6 activities and 30 subjects)

#Renaming the first 2 columns (grouping columns)
names(averages_table)[1] <- "activity"
names(averages_table)[2] <- "subject"

#And renaming the average columns for each selected feature 
#by adding the "avg-" prefix
names(averages_table)[3:81] <- sapply(names(averages_table)[3:81],function(s) paste0("avg-",s))
