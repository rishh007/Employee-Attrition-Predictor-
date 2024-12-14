# Load necessary libraries
library(caret)
library(randomForest)
library(ROSE)

# Load the dataset
dataset <- read.csv("dataset.csv")

# Convert categorical variables to factors
dataset$Attrition <- as.factor(dataset$Attrition)
dataset$JobRole <- as.factor(dataset$JobRole)
dataset$MaritalStatus <- as.factor(dataset$MaritalStatus)
dataset$OverTime <- as.factor(dataset$OverTime)

# class distribution b4 ovun
table(dataset$Attrition)

# Oversampling yes and undersampling no.....have used ovun sample instead of SMOTE
set.seed(123)  # For reproducibility
balanced_data <- ovun.sample(Attrition ~ ., data = dataset, 
                             method = "both", 
                             N = 735*2, 
                             seed = 1)$data

# Standardize the numerical features
num_vars <- c("Age", "JobLevel", "MonthlyIncome", "StockOptionLevel", "TotalWorkingYears")
preProc <- preProcess(balanced_data[, num_vars], method = c("center", "scale"))
balanced_data[, num_vars] <- predict(preProc, balanced_data[, num_vars])


table(balanced_data$Attrition)


#Cross validation-12
train_control <- trainControl(method = "cv", number = 12)

# Training RF model
set.seed(123) 
rf_model <- train(Attrition ~ ., data = balanced_data, method = "rf", 
                  trControl = train_control, 
                  tuneLength = 5)


#saveRDS(rf_model, "rf_model.rds")