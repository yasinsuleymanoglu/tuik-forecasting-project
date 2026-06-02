# ==============================================================================
# SCRIPT: forecasting_methods.R
# PURPOSE: Implement forecasting models for ANNUAL time series data (freq = 1)
# AUTHOR: Yasin Süleymanoğlu
# ==============================================================================

suppressPackageStartupMessages({
  library(forecast)
  library(dplyr)
})

# Since the data is annual, we can only use non-seasonal models.
h_period <- 5 # Forecasting next 5 years

# 1. Naive Method (Random Walk)
fc_naive <- naive(poultry_ts, h = h_period)

# 2. Drift Method (Random Walk with Drift)
fc_drift <- rwf(poultry_ts, h = h_period, drift = TRUE)

# 3. Simple Exponential Smoothing (SES) - For data with no clear trend
fc_ses <- ses(poultry_ts, h = h_period)

# 4. Holt's Linear Trend Method - For data with a trend but no seasonality
fc_holt <- holt(poultry_ts, h = h_period)

# 5. Damped Holt's Trend Method
fc_holt_damped <- holt(poultry_ts, h = h_period, damped = TRUE)

# 6. Non-Seasonal ARIMA (Auto-ARIMA)
fit_arima <- auto.arima(poultry_ts, seasonal = FALSE, stepwise = FALSE, approximation = FALSE)
fc_arima <- forecast(fit_arima, h = h_period)

# 7. Non-Seasonal Neural Network Auto-Regression (NNETAR)
set.seed(42) # For reproducibility
fit_nnetar <- nnetar(poultry_ts)
fc_nnetar <- forecast(fit_nnetar, h = h_period)

# 8. Simple Linear Regression (Trend only)
time_trend <- seq_along(poultry_ts)
fit_lm <- tslm(poultry_ts ~ trend)
fc_lm <- forecast(fit_lm, h = h_period)

# 9. Theta Method (Works well for annual data)
fc_theta <- thetaf(poultry_ts, h = h_period)

# 10. Spline Forecasting (Cubic Smoothing Splines)
fc_spline <- splinef(poultry_ts, h = h_period)

# Combine all forecasts in a list for evaluation
all_forecasts <- list(
  Naive = fc_naive,
  Drift = fc_drift,
  SES = fc_ses,
  Holt = fc_holt,
  Holt_Damped = fc_holt_damped,
  ARIMA = fc_arima,
  NNETAR = fc_nnetar,
  Linear_Trend = fc_lm,
  Theta = fc_theta,
  Spline = fc_spline
)

message("Tüm yıllık tahmin modelleri (frekans=1) başarıyla çalıştırıldı!")
