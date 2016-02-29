
#call required packages. 
library("data.table")
library("reshape2")

# We assume that the downloaded file is in the working directory.

Activity_types <- read.table("./UCI HAR Dataset/Activity_types.txt")[,2]


features <- read.table("./UCI HAR Dataset/features.txt")[,2]


extract_features <- grepl("mean|std", features)

X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")

names(X_test) = features

X_test = X_test[,extract_features]


y_test[,2] = Activity_types[y_test[,1]]
names(y_test) = c("Activity", "Activity_type")
names(subject_test) = "subject"

test_data <- cbind(as.data.table(subject_test), y_test, X_test)

X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")

subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
names(X_train) = features

X_train = X_train[,extract_features]

# Load activity data
y_train[,2] = Activity_types[y_train[,1]]
names(y_train) = c("Activity", "Activity_type")
names(subject_train) = "subject"

train_data <- cbind(as.data.table(subject_train), y_train, X_train)

# Now, merge test and train tables
data = rbind(test_data, train_data)

id_labels   = c("subject", "Activity", "Activity_type")
data_labels = setdiff(colnames(data), id_labels)
DATA      = melt(data, id = id_labels, measure.vars = data_labels)

Tidy_Data   = dcast(DATA, subject + Activity_type ~ variable, mean)

write.table(Tidy_Data, file = "./tidy_data.txt")
