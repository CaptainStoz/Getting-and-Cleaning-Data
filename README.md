The r script run_analysis.r does the following.
1. It merges the training and test data sets found at: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

2. The training files are: subject_train.txt, X_train.txt and y_train.txt the test data files are: subject_test.txt, X_test.txt and y_test.txt  The data fields were pulled from features.txt and features_info.txt

3. The measurements related to mean and standard deviation were extracted and imported into a new dataset all_data.txt

4. A second "tidy" data set was all_average.txt created from all_data that grouped the average (mean) for each measurement by each activity and subject:

5. Please see Codebook.md for the fields names and lenghts.
