# clean_data.R
# Data Cleaning & Formatting Script
# Final Project for Data 330
# Done by Trishelle Leal

library(dplyr)
library(readr)
library(lubridate)


## Functions

# Clean daily exchange data
clean_daily_data <- function(df) {
  df %>%
    mutate(
      Date = as.Date(Date),
      start_rate = as.numeric(start_rate),
      end_rate = as.numeric(end_rate),
      change = as.numeric(change)
    ) %>%
    distinct() %>%
    arrange(Date)
}

## Clean historical exchange data
clean_historical_data <- function(df) {
  df %>%
    mutate(
      date = as.Date(date),
      rate = as.numeric(rate)
    ) %>%
    distinct() %>%
    arrange(date)
}


## SCRIPT 

## Cleaning daily data

daily_file <- "data/MXNUSD_ExchData.csv"
if (!file.exists(daily_file)) {
  stop("Daily data file not found: data/MXNUSD_ExchData.csv")
}

daily_raw <- read_csv(daily_file, show_col_types = FALSE)

# Apply cleaning function
daily_clean <- clean_daily_data(daily_raw)

# Save cleaned version
write_csv(daily_clean, "data/MXNUSD_ExchData.csv")


## Load historical data

today <- Sys.Date()
md <- format(today, "%m-%d")
hist_file <- paste0("data/historical/USDMXN_", md, ".csv")

if (!file.exists(hist_file)) {
  stop(paste("Historical data file not found:", hist_file))
}

hist_raw <- read_csv(hist_file, show_col_types = FALSE)

# Apply cleaning function
hist_clean <- clean_historical_data(hist_raw)

# Save cleaned version
write_csv(hist_clean, paste0("data/historical/USDMXN_", md, ".csv"))


