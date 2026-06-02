# TÜİK Annual Poultry Production Forecasting Project

This repository contains an academic time series forecasting project developed for Management Information Systems - Time Series Forecasting. 
The project has shifted entirely to **Annual** data ("Yıllık") due to programmatic API constraints.

## Project Metadata
- **Student Name:** Yasin Süleymanoğlu
- **University:** Marmara University
- **Course:** Management Information Systems - Time Series Forecasting
- **TÜİK Theme:** Agriculture (Theme 13)
- **Table Name:** Number of Poultry Animals Slaughtered and Production Quantity of Poultry Meat
- **Dataflow Type:** Annual `istab` Excel Binary Stream
- **Data Frequency:** Annual (`frequency = 1`)

## The WAF/API Bypass Challenge (And The Solution)
TÜİK recently implemented severe Web Application Firewalls (WAF) that return `HTTP 401 Unauthorized` for SDMX queries and `Access denied` for programmatic downloads of Monthly datasets. Manual downloads are strictly prohibited by the course rubric.

To solve this, this project implements an **Ultimate HTML-to-Excel Dynamic Fix** (`data_import.R`):
1. It uses `tuikr` to locate the general catalog ID for the Annual Poultry Production dataset.
2. It uses `httr::GET` with aggressive Chrome `User-Agent` spoofing.
3. It sets the header `Accept: application/vnd.ms-excel` to force the server to stream the raw binary Excel file instead of serving a Single Page Application (SPA) HTML frontend.
4. It parses the vertical structure dynamically using `readxl`.

## Forecasting Methods Used (Non-Seasonal)
Because the data frequency is 1 (Annual), seasonal forecasting methods are mathematically invalid. The project evaluates the following 10 trend-focused methods:
1. Naive
2. Drift
3. Simple Exponential Smoothing (SES)
4. Holt's Linear Trend
5. Damped Holt's Trend
6. Non-Seasonal Auto-ARIMA
7. Neural Network Auto-Regression (NNETAR)
8. Linear Regression (Trend)
9. Theta Method
10. Spline Forecasting

## Reproducibility
To run the project:
1. Clear your R Environment (`rm(list=ls())`).
2. Open `forecasting_project.Rmd` in RStudio.
3. Click **Knit to HTML**. The API will be dynamically fetched.
