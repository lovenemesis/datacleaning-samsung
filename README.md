# datacleaning-samsung #

A utility R script to generate a tidy form of data from [Human Activity Recognition Using Smartphones Dataset](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)[1]. The license of dataset can be viewed at the bottom.

----------------------------------

## Steps to Use ##

- Download dataset from [UCI HAR Dataset](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip). Unzip it to a folder called "UCI HAR Dataset".
- Download run_analysis.R script and put it in the same folder as "UCI HAR Dataset" a.k.a under one parent folder.
- Run the script. Note it assumes all the data are stored in the folder of "UCI HAR Dataset" with content unmodified. If the name or the  inner structure is modified, please edit the script accordingly. Note you should have at least 100MB free memory.
- A space separated plain text file called "tidydata.txt" will be generated in the same folder, if everything goes as plan. 

### About the Dataset  ###

The dataset contains measured accelerometer and gyroscope signals on a Samsung Galaxy II attached to a human subject. Six activities on 30 volunteers were recorded and manually labled afterwards. Various treatment were done to the dataset and the subjects were randomly selected into 70% train and 30% test sets. More details on README.txt in unzipped folder.

### About the transform ###

The original data were composed by features, activity lables and two separate training and test sets. This script will first construct the train and test sets with appropriate subject and activity lable. Then it will merge two sets into one based on variables names. Next treatments of mean and standard deviation will be picked up to form a new dataset. Note the weighted mean and supplenmentary varaibles for angle are excluded. Finally the dataset will be melt and re-casted into a tidy form using reshape2 package. 

It's considered as tidy because it meets the tidy data criteria set by [Leek, Taub and Pineda 2011 PLoS One](http://www.plosone.org/article/info%3Adoi%2F10.1371%2Fjournal.pone.0026895): Each observation forms a row while each variable forms a column.


----------------------------------


## Dataset License ##

[1]Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

This dataset is distributed AS-IS and no responsibility implied or explicit can be addressed to the authors or their institutions for its use or misuse. Any commercial use is prohibited.