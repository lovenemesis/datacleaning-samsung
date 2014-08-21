features <- read.table(file.path("UCI HAR Dataset", "features.txt"),
                       stringsAsFactors = FALSE)

Xtrain <- read.table(file.path("UCI HAR Dataset", "train", "X_train.txt"),
                     stringsAsFactors = FALSE)
ytrain <- read.table(file.path("UCI HAR Dataset", "train", "y_train.txt"))
subject_train <- read.table(file.path("UCI HAR Dataset", "train", "subject_train.txt"),
                            stringsAsFactors = FALSE)

trainset <- cbind(subject_train, ytrain, Xtrain, stringsAsFactors = FALSE)
names(trainset) <- c("Subject", "Activity", features[,2])
rm(subject_train, ytrain, Xtrain)

Xtest <- read.table(file.path("UCI HAR Dataset", "test", "X_test.txt"),
                    stringsAsFactors = FALSE)
ytest <- read.table(file.path("UCI HAR Dataset", "test", "y_test.txt"))
subject_test <- read.table(file.path("UCI HAR Dataset", "test", "subject_test.txt"),
                            stringsAsFactors = FALSE)

testset <- cbind(subject_test, ytest, Xtest, stringsAsFactors = FALSE)
names(testset) <- c("Subject", "Activity", features[,2])
rm(subject_test, ytest, Xtest)

totalset <- rbind(trainset, testset)
rm(trainset, testset)

totalset$Activity <- gsub("1", "WALKING", totalset$Activity)
totalset$Activity <- gsub("2", "WALKING_UPSTAIRS", totalset$Activity)
totalset$Activity <- gsub("3", "WALKING_DOWNSTAIRS", totalset$Activity)
totalset$Activity <- gsub("4", "SITTING", totalset$Activity)
totalset$Activity <- gsub("5", "STANDING", totalset$Activity)
totalset$Activity <- gsub("6", "LAYING", totalset$Activity)
totalset$Activity <- as.factor(totalset$Activity)

meanstdset <- totalset[c(TRUE, TRUE, grepl("(mean\\(\\))|(std\\(\\))", features[,2]))]
rm(totalset, features)

names(meanstdset) <- gsub("(^t)", "Time", names(meanstdset))
names(meanstdset) <- gsub("(^f)", "Frequency", names(meanstdset))
names(meanstdset) <- gsub("(mean\\(\\))", "Mean", names(meanstdset))
names(meanstdset) <- gsub("(std\\(\\))", "Std", names(meanstdset))


ifelse(require(reshape2),
       library(reshape2),
       { install.packages(reshape2)
         library(reshape2)
         })

setMelt <- melt(meanstdset,id.vars = c("Subject", "Activity"))
setCast <- dcast(setMelt, Subject + Activity ~ variable, fun.aggregate = mean)
rm(meanstdset, setMelt)

write.table(setCast, file = "tidydata.txt", row.names = FALSE)
rm(setCast)

tidydata <- read.table("tidydata.txt", header = TRUE)