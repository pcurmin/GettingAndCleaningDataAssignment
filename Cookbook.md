---
title: Course 3 project cookbook
author: Philippe Curmin
output: html_document
---

###Prepare the data (manual steps)

####a. Extract the downloaded zip file to a folder "course 3 project", with 2 subfolders "test" and "train"

####b. Copy all test data under the "test" subfolder, the "Inertial Signals" folder under "test" will be ignored

####c. Copy all training data under the "train" subfolder, the "Inertial Signals" folder under "test" will be ignored

####d. Keep "activity_labels" and "features" files under the main "course 3 project" folder

####e. Copy the source file "run_analysis.R" in the main "course 3 project" folder, which is the workspace.

###Automated tasks (running the script)

###First tidy table: mean and standard derivation features for each subject and activity

All files are read with the read.table() function.

The general principle is to collect data for both "test" and "train" sets column by column (using the rbind() function), and then to merge columns into a single data frame (using the cbind() function).

####1. Read the subject data (2 "subject_*.txt" files in the "test" and "train" folders) and merge them into one "subjects" table 

The result has 1 variable (the numeric id of the subject) and 10299 observations.

####2. Read the activities data (2 "y_*.txt" files in the "test" and "train" folders) and merge them into one "activity_numbers" table

The result has 1 variable (the numeric id of the activity) and 10299 observations. All activity numbers are in 1:6.

####3. Read the activity labels (one "activity_labels.txt" file in the workspace), as a vector of strings

####4. Use this vector of strings to replace each activity number by its label, building the "activities" vector

The result has 1 variable (the label of the activity) and 10299 observations.

####5. Read the features data (2 "X_*.txt" files in the "test" and "train" folders) and merge them into one "features" table 

The result has 561 variables and 10299 observations.

####6. Read the features names (one "features.txt" file in the workspace), as a vector of strings

####7. Merge the subjects, activities and features tables (in this order, using the cbind() function), but select only the features columns with a name containing the  "mean" or "std" string. And set the name for the first 2 columns: "subject" and "activity".

The result "result_table" is a data frame with 81 variables and 10299 observations.

The variables are: subject, activity, and the 79 features from the original data with "mean" or "std" in their name.

###Second tidy table: for each activity and subject, the average of each mean and standard derivation feature

We start from the table "result_table" obtained at the previous step.

####1. We use the aggregate() function to group the mean() of each feature from the first table by activity and group

The result has 81 variables and 180 observations: 6 activities and 30 subjects, hence 180 groups of 79 average values.

####2. At the end we set the names of the first 2 columns as "activity" and "subject"

####3. And we append "avg-" to the names of the 79 variables corresponding to the average values of the mean and std features.

The result "averages_table" is a data frame with 81 variables and 180 observations: activity, subject, 79 average variables of the form "avg-*mean()*" or "avg-*std()*".
