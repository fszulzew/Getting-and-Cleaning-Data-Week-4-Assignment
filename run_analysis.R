library(dplyr)

# 0. Reading data
  # 1.1 Read train data
  x_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
  y_train <- read.table("./UCI HAR Dataset/train/Y_train.txt")
  subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

  # 0.2 Reading test data
  x_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
  y_test <- read.table("./UCI HAR Dataset/test/Y_test.txt")
  subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")

  # 0.3 Reading data description
  features <- read.table("./UCI HAR Dataset/features.txt")

  # 0.4 Reading activity labels
  activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")


# 1.Merge the training and the test sets to create one data set.
  x_merge <- rbind(x_train, x_test)
  y_merge <- rbind(y_train, y_test)
  subject_merge <- rbind(subject_train, subject_test)


# 2.Extract only the measurements on the mean and standard deviation for each measurement.
  mean_and_std <- features[grep("mean\\(\\)|std\\(\\)",features[,2]),]
  x_merge <- x_merge[,mean_and_std[,1]]


# 3.Use descriptive activity names to name the activities in the data set
  colnames(y_merge) <- "activity"
  y_merge$activitylabel <- factor(y_merge$activity, labels = as.character(activity_labels[,2]))
  activitylabel <- y_merge[,-1]


# 4.Appropriately label the data set with descriptive variable names.
  colnames(x_merge) <- features[mean_and_std[,1],2]


# 5.From the data set in step 4, creates a second, independent tidy data set with the average
# of each variable for each activity and each subject.
  colnames(subject_merge) <- "subject"
  xy_merge <- cbind(x_merge, activitylabel, subject_merge)
  tidydata <- xy_merge %>% group_by(activitylabel, subject) %>% summarise_each(funs(mean))
  write.table(tidydata, file = "./tidydataset.txt", row.names = FALSE)