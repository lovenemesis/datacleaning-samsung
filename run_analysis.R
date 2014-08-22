#Read variable names from features.txt
features <- read.table(file.path("UCI HAR Dataset", "features.txt"),
                       stringsAsFactors = FALSE)

#Read various train tables
Xtrain <- read.table(file.path("UCI HAR Dataset", "train", "X_train.txt"),
                     stringsAsFactors = FALSE)
ytrain <- read.table(file.path("UCI HAR Dataset", "train", "y_train.txt"))
subject_train <- read.table(file.path("UCI HAR Dataset", "train", "subject_train.txt"),
                            stringsAsFactors = FALSE)

#Combine tables into one set with sensible names
trainset <- cbind(subject_train, ytrain, Xtrain, stringsAsFactors = FALSE)
names(trainset) <- c("Subject", "Activity", features[,2])
rm(subject_train, ytrain, Xtrain)

#Read various test tables
Xtest <- read.table(file.path("UCI HAR Dataset", "test", "X_test.txt"),
                    stringsAsFactors = FALSE)
ytest <- read.table(file.path("UCI HAR Dataset", "test", "y_test.txt"))
subject_test <- read.table(file.path("UCI HAR Dataset", "test", "subject_test.txt"),
                            stringsAsFactors = FALSE)

#Combine tables into one set with senisble names
testset <- cbind(subject_test, ytest, Xtest, stringsAsFactors = FALSE)
names(testset) <- c("Subject", "Activity", features[,2])
rm(subject_test, ytest, Xtest)

#Combine train and set into a single set by corresponding variables, free the memeory afterwards
totalset <- rbind(trainset, testset)
rm(trainset, testset)

#Replace number with meaningful names in Activity, according to activity_labels.txt
totalset$Activity <- gsub("1", "WALKING", totalset$Activity)
totalset$Activity <- gsub("2", "WALKING_UPSTAIRS", totalset$Activity)
totalset$Activity <- gsub("3", "WALKING_DOWNSTAIRS", totalset$Activity)
totalset$Activity <- gsub("4", "SITTING", totalset$Activity)
totalset$Activity <- gsub("5", "STANDING", totalset$Activity)
totalset$Activity <- gsub("6", "LAYING", totalset$Activity)
totalset$Activity <- as.factor(totalset$Activity)

#Subset only the measurements of mean and standard deviation
meanstdset <- totalset[c(TRUE, TRUE, grepl("(mean\\(\\))|(std\\(\\))", features[,2]))]
rm(totalset, features)

#Refine variable names of measurement of mean and standard deviation
names(meanstdset) <- gsub("(^t)", "Time", names(meanstdset))
names(meanstdset) <- gsub("(^f)", "Frequency", names(meanstdset))
names(meanstdset) <- gsub("(mean\\(\\))", "Mean", names(meanstdset))
names(meanstdset) <- gsub("(std\\(\\))", "Std", names(meanstdset))

#Load reshape2 package, install from CRAN if not avaiable
ifelse(require(reshape2),
       library(reshape2),
       { install.packages(reshape2)
         library(reshape2)
         })

#Melt the set into narrow form
setMelt <- melt(meanstdset,id.vars = c("Subject", "Activity"))

#Reshape into a tidy wide form by averaging measurement for each activity
setCast <- dcast(setMelt, Subject + Activity ~ variable, fun.aggregate = mean)
rm(meanstdset, setMelt)

#Write into a space separated text file.
write.table(setCast, file = "tidydata.txt", row.names = FALSE)
rm(setCast)

#Read text file into workspace if necessary
tidydata <- read.table("tidydata.txt", header = TRUE)