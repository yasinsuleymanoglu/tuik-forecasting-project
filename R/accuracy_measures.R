# ==============================================================================
# SCRIPT: accuracy_measures.R
# PURPOSE: Calculate comprehensive accuracy metrics for annual forecasting models
# AUTHOR: Yasin Süleymanoğlu
# ==============================================================================

suppressPackageStartupMessages({
  library(forecast)
  library(dplyr)
})

# Generate in-sample accuracy metrics for all models
calculate_accuracy_table <- function(forecast_list) {
  acc_results <- data.frame()
  
  for (model_name in names(forecast_list)) {
    fc <- forecast_list[[model_name]]
    
    # Use forecast::accuracy() to easily grab standard metrics
    acc_matrix <- forecast::accuracy(fc)
    
    # Check if we have MASE in the accuracy matrix (usually column 6)
    rmse_val <- acc_matrix[1, "RMSE"]
    mae_val <- acc_matrix[1, "MAE"]
    mape_val <- acc_matrix[1, "MAPE"]
    
    # If MASE exists in the accuracy output, grab it. Otherwise, compute manually.
    if("MASE" %in% colnames(acc_matrix)) {
      mase_val <- acc_matrix[1, "MASE"]
    } else {
      # Manual MASE for frequency = 1
      actuals <- fc$x
      naive_mae <- mean(abs(diff(actuals)), na.rm = TRUE)
      mase_val <- mae_val / naive_mae
    }
    
    # Calculate Tracking Signal
    errors <- fc$x - fc$fitted
    mad_val <- mae_val
    cumulative_error <- sum(errors, na.rm = TRUE)
    tracking_signal <- cumulative_error / mad_val
    
    acc_results <- rbind(acc_results, data.frame(
      Model = model_name,
      RMSE = rmse_val,
      MAE = mae_val,
      MAPE = mape_val,
      MASE = mase_val,
      TrackingSignal = tracking_signal
    ))
  }
  
  return(acc_results)
}

# Run the function on our list of models
accuracy_table <- calculate_accuracy_table(all_forecasts)

# Arrange by RMSE to find the most accurate model
accuracy_table <- accuracy_table %>% arrange(RMSE)

# Select the best model (ARIMA or Holt usually wins for structural annual trends)
best_model_name <- accuracy_table$Model[1]
best_model <- all_forecasts[[best_model_name]]

message(sprintf("Doğruluk metrikleri hesaplandı. En başarılı model: %s", best_model_name))
