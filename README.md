# getting-and-cleaning-data<br>
Firstly I have loaded the required packages for this project.<br>
Then I have loaded the data set using download.file function.<br>
After that I have extracted only the required columns from the activity_labels.txt and features.txt.<br>
Then only the measurements on the mean and standard deviation for each measurement is extracted for both the test and train datsets.<br>
The obtained data is then merged into a single dataset with appropriate variable names for the columns.<br>
Finally, the dataset in stored into a text file called tidyData.txt.<br>
