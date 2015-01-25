setwd("C:/Users/Perrier/Desktop/Getting and Cleaning Data/Course Project/UCI HAR Dataset")
require(data.table)
require(dplyr)
options(digits = 3)

### 1. Read in all files of interest and combine relevant data ###
features <- read.table("features.txt", sep = "")
activity_labels <- read.table("activity_labels.txt", sep = "", col.names = c("activity_id", "activity_type"))
x_data <- rbind(read.table("train/X_train.txt", sep = ""), (read.table("test/X_test.txt", sep = "")))

subjects_activity <- 
 cbind(
 rbind(read.table("train/subject_train.txt", sep = "", col.names = "subject_id"), 
       read.table("test/subject_test.txt", sep = "", col.names = "subject_id")),
 rbind(read.table("train/y_train.txt", sep = "", col.names = "activity"), 
       read.table("test/y_test.txt", sep = "", col.names = "activity")))

### 2. Relabel column names and create separate vector of names ###
x_names <- (names(x_data) <- features[ ,2])

### 3. Extract means and standard deviations ###
means <- (grepl("mean()", x_names) & !grepl("-meanFreq", x_names))
stdev <- (grepl("-std()", x_names) & !grepl("-stdFr", x_names))

### 4. Create dataset of extracted data and provide descriptive labels ###
full_dataset <- (data.table(x_data[ ,means], (x_data[ ,stdev]), subjects_activity))

to_replace <- c("^t","^f","Acc", "BodyBody" , "Gyro", "Mag")
replace_with <- c("time", "frequency", "Accelerometer", "Body", "Gyroscope", "Magnitude") 

multi_gsub <- function(old_names, to_set, data, set_sub, ...) {
 sub <- names(data)
 set_sub <- setnames
 if(0 %in% (charmatch(to_set, sub))) stop("Names have already been replaced.") 
   for(i in 1:length(old_names)) {
     sub <- gsub(old_names[i], to_set[i], sub, ...)  
     }
     set_sub(data, names(data), sub)  
   }

multi_gsub(to_replace, replace_with, full_dataset)
full_dataset$activity <- cut(full_dataset$activity, breaks = c(0, 1, 2, 3, 4, 5, 6), labels = c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING","STANDING", "LAYING")) 

## 5. With the final tidied dataset, create a dataset of averages ### 
dataset_averages <- (aggregate(. ~subject_id + activity, full_dataset, mean))
dataset_averages <- dataset_averages[order(dataset_averages$subject_id, dataset_averages$activity), ]

write.table(dataset_averages, file = "dataset_averages.txt", row.names = F)
