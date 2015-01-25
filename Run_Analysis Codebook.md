<h4>Run_Analysis Codebook</h4>
This script performs a number of steps to accomplish the goal of tidy data. The purpose of each variable for each step are described here.

(Note: Packages utilized include the data.table and ddply.)

Step 1. First, the necessary data from the files listed above are extracted and merged when applicable.

- features: used for the column names of x_data
- activity_labels: this provides activity labels (1:6) and their corresponding activity names
- subjects_activity: this stores training and test subject IDs and activity labels after merging them by row and column
- x_data: this dataset contains merges the data within X_test and X_train by rbind

Step 2. Next, the means and standard deviations are extracted and merged into a dataset with subject and activity labels

- means: logical vector for extracting the mean data from x_data by specifying patterns
- stdev: logical vector for extracting standard deviation data, similar to the above
- full_dataset: a complete dataset containing the extracted data above, the subject IDs, and the activity labels

Step 3. For columns with ambiguous names, a function matches specified partial strings and replaces them accordingly.

- to_replace: vector of partial strings to match for replacement
- replace_with: vector of strings for replacement
- multi_gsub: function for performing multiple substitutions and setting names

Step 4. Activity labels are substituted with their respective activity names using the cut function.

```{r}
full_dataset$activity <-  cut(full_dataset$activity, breaks = c(0, 1, 2, 3, 4, 5, 6),
     labels = c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING", "LAYING")) 
```

Step 5. Finally, the averages of all measurements for each subject and activity are stored in a new dataset.

- dataset_averages: the averages of every measurement for each subject and activity are calculated; the dataset is then ordered by subject and activity
