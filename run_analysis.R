 # to read the test dataset 
   read_test_data = function() { 
     r_Data("test", "test") 
   } 
 
 
   # reading the train dataset 
   read_train_data = function () { 
     r_Data("train", "train") 
  } 
 
 
   # merging the two datasets and giving proper column names 
   mergeDataset = function () { 
     dataset = rbind(read_test_data(), read_train_data()) 
     cnames = colnames(dataset) 
     cnames = gsub("\\.+mean\\.+", cnames, replacement = "Mean") 
     cnames = gsub("\\.+std\\.+", cnames, replacement = "Std") 
     colnames(dataset) = cnames 
     dataset 
   } 

  # Reading the activity labels and creating a column for activity labels  
	 activityLabels = function (dataset) { 
     activity_labels = read.table("activity_labels.txt", header = FALSE, as.is=TRUE, col.names = c("ActivityID", "ActivityName")) 
     activity_labels$ActivityName = as.factor(activity_labels$ActivityName) 
     data_labels = merge(dataset, activity_labels) 
     data_labels 
    } 
 
 
  # merging the activity labels to the merged dataset 
     merge_label_data = function () { 
     activityLabels(mergeDataset()) 
    } 
 
 
   # Creating a second, independent tidy data set with the average of each variable for each activity and each subject.  
     tidyData = function(merge_label_data) { 
     library(reshape2) 
    
     vars = c("ActivityID", "ActivityName", "SubjectID") 
     measure_vars = setdiff(colnames(merge_label_data), vars) 
     melted_data <- melt(merge_label_data, id=vars, measure.vars=measure_vars) 
    
    # recast  
    dcast(melted_data, ActivityName + SubjectID ~ variable, mean) 
    } 
  
 
    #Getting the clean tidy dataset 
     tidy_datafile =function(fname){ 
     tidy_data = tidyData(merge_label_data()) 
     write.table(tidy_data, fname) 
   } 
 
 
   tidy_datafile("tidy.txt") 
