# ==============================================================================
# SCRIPT: plots.R
# PURPOSE: Generate time series visualizations for ANNUAL data
# AUTHOR: Yasin Süleymanoğlu
# ==============================================================================

suppressPackageStartupMessages({
  library(forecast)
  library(ggplot2)
})

# 1. Plot Historical Data (Time Plot)
# Visualizes the annual trend in poultry production
plot_historical_data <- function(ts_data) {
  autoplot(ts_data) +
    ggtitle("Yıllık Kümes Hayvancılığı Üretimi (Türkiye)") +
    xlab("Yıllar") +
    ylab("Üretim Miktarı (Ton)") +
    theme_minimal() +
    theme(
      plot.title = element_text(face = "bold", size = 14, hjust = 0.5),
      axis.title.x = element_text(face = "bold"),
      axis.title.y = element_text(face = "bold")
    )
}

# 2. ACF and PACF Plots
# Helps identify AR and MA terms for ARIMA modeling
plot_acf_pacf <- function(ts_data) {
  p1 <- ggAcf(ts_data) + ggtitle("Otokorelasyon (ACF)")
  p2 <- ggPacf(ts_data) + ggtitle("Kısmi Otokorelasyon (PACF)")
  
  gridExtra::grid.arrange(p1, p2, ncol = 2)
}

# 3. Best Model Forecast Plot
# Plots the forecast and confidence intervals of the winning model
plot_best_forecast <- function(best_forecast) {
  autoplot(best_forecast) +
    ggtitle(sprintf("Gelecek 5 Yıllık Kümes Hayvancılığı Üretim Tahmini (%s Modeli)", best_forecast$method)) +
    xlab("Yıllar") +
    ylab("Tahmini Üretim (Ton)") +
    theme_minimal() +
    theme(
      plot.title = element_text(face = "bold", size = 14, hjust = 0.5),
      axis.title.x = element_text(face = "bold"),
      axis.title.y = element_text(face = "bold")
    )
}

# 4. Model Comparison (Residuals) Plot
# Visualizes the residuals to ensure they behave like white noise
plot_residuals <- function(best_forecast) {
  checkresiduals(best_forecast)
}
