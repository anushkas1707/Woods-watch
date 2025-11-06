# Woods-watch
Indian Forest cover anomaly detection model.

This R project analyzes Indian state-wise forest cover data (2011-2021) to detect anomalies and predict trends using Random Forest and Isolation Forest models. Includes data validation, interactive dashboards, and visualizations.

## Features
- Data cleaning and preprocessing for forest metrics
- Predictive modeling (Random Forest for forest area forecasting)
- Anomaly detection (Isolation Forest for outlier forest changes)
- Unit testing with testthat
- Interactive dashboard with flexdashboard and ggplot2

## Setup
1. Clone this repo.
2. Place `indian_forest_data_2011_2021.csv` in `data/raw/`.
3. Install packages and run `source("scripts/run_all.R")`.

## Dataset
- Source: ISFR 2023 (extracted from PDF).
- Columns: State, Year, Forest_Area_sqkm, Geographical_Area_sqkm.
