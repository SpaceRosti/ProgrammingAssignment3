## How to run :
You can use the function tidydata(). It will download the data sets if they are not,applied all the functions and return a data frame contening a tidy data set.

------------------------------------------------------------------------------------------------------------------------------------------

## Function : 

# In the order in wich they should be called :

1)downloadzipfile() : Download the files and check if they already exist.

2)mergedata() : Merge the data sets and return it.

3)takemeanstd(x = data.frame()) : Extracts the measurements on the mean and standard deviation and return the data frame.

4)usenames(ok = data.frame()) : Change the activity number by his name and return the data frame.

5)uselabel(x = data.frame()) : Label the data set with descriptive variable names and return the data frame.

6)createaverage(x=data.frame()) :  Create a data set with the average of each variable for each activity and each subject and return the data frame.


# To use all the previous function in one call :

tidydata() : Combine all the previous function and return a tidy data set.
