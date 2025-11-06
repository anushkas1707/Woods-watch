library(caret)
library(randomForest)
library(solitude)

# Load processed data
forest_data_scaled <- read.csv("data/processed/forest_data_processed.csv")

# Split data (use Year for time-based split if needed)
set.seed(123)
train_index <- createDataPartition(forest_data_scaled$Forest_Area_sqkm, p = 0.7, list = FALSE)
train_data <- forest_data_scaled[train_index, ]
test_data <- forest_data_scaled[-train_index, ]

# Random Forest for predicting Forest Area (regression)
rf_model <- train(Forest_Area_sqkm ~ Geographical_Area_sqkm + Forest_Cover_Percentage + Year,
                  data = train_data,
                  method = "rf",
                  trControl = trainControl(method = "cv", number = 5),
                  tuneLength = 5)
rf_pred <- predict(rf_model, test_data)
rf_rmse <- RMSE(rf_pred, test_data$Forest_Area_sqkm)

# Isolation Forest for Anomalies (on forest area changes)
if_model <- isolationForest(train_data[, c("Forest_Area_sqkm", "Geographical_Area_sqkm", "Forest_Cover_Percentage")])
anomaly_scores <- predict(if_model, test_data[, c("Forest_Area_sqkm", "Geographical_Area_sqkm", "Forest_Cover_Percentage")])
test_data$anomaly_score <- anomaly_scores$anomaly_score
threshold <- quantile(test_data$anomaly_score, 0.95)
test_data$anomaly <- ifelse(test_data$anomaly_score > threshold, "Anomaly", "Normal")

# Save results
saveRDS(rf_model, "data/processed/rf_forest_model.rds")
write.csv(test_data, "data/processed/test_forest_with_anomalies.csv", row.names = FALSE)

cat("RMSE:", round(rf_rmse, 2), "\nAnomaly Rate:", round(mean(test_data$anomaly == "Anomaly"), 2), "\n")
