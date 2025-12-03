# Final project for Data 330 
# Visualization Script
# Done by Trishelle Leal 

library(dplyr)
library(ggplot2)
library(readr)
library(lubridate)

# Create plots folder if missing
dir.create("plots", showWarnings = FALSE)

daily_file <- "data/MXNUSD_ExchData.csv"

if (!file.exists(daily_file)) {
  stop("Daily data file not found: data/MXNUSD_ExchData.csv")
}

daily <- read_csv(daily_file, show_col_types = FALSE)

# Ensure Date is Date type
daily <- daily %>% mutate(Date = as.Date(Date))
seven_day_start <- today - 7
daily_7 <- daily %>% filter(Date >= seven_day_start)


# Rate from daily API
today_rate <- tail(daily_7$end_rate, 1)

## Safety net
### I don't have a full week of data by the time im testing this.
if (nrow(daily_7) >= 2) {
  yesterday_rate <- daily_7$end_rate[nrow(daily_7) - 1]
} else {
  yesterday_rate <- NA
}

if (is.na(yesterday_rate)) {
  today_color <- "gray50"   # Not enough data: neutral color
} else if (today_rate < yesterday_rate) {
  today_color <- "green3" # If the Peso went UP
} else {
  today_color <- "red3" # RIP 
}

### WEEKLY DATA VIZ
#### This visualization shows the last week and compares today to how the Peso has been doing compared to it.
p_last7 <- ggplot() +
  geom_line(data = daily_7, aes(x = Date, y = end_rate), linewidth = 1.2, color = "gray40") +
  
  # Today's colored point
  geom_point(aes(x = today, y = today_rate), color = today_color, size = 4) +
  
  labs(
    title = "USD/MXN: Last 7 Days",
    x = "Date",
    y = "Exchange Rate (MXN per USD)",
    caption = "Green = MXN strengthened today - Red = MXN weakened today"
  ) +
  theme_minimal(base_size = 14)

# Save the plot
ggsave("plots/last7_comparison_colored.png", p_last7, width = 10, height = 6)



## Loading historical data
today <- Sys.Date()
md <- format(today, "%m-%d")
hist_file <- paste0("data/historical/USDMXN_", md, ".csv")

if (!file.exists(hist_file)) {
  stop(paste("Historical data file not found:", hist_file))
}

historical <- read_csv(hist_file, show_col_types = FALSE)
historical <- historical %>% mutate(date = as.Date(date))


## Historical line plot
### Shows today compared to the last 5 years (on this exact same date)
p_hist <- ggplot(historical, aes(x = date, y = rate)) +
  geom_line(linewidth = 1.1) +
  labs(
    title = "USD / MXN Exchange Rate (Last 5 Years)",
    x = "Date",
    y = "Exchange Rate (MXN per USD)"
  ) +
  theme_minimal(base_size = 14)

ggsave("plots/historical_exchange_rate.png", p_hist, width = 10, height = 6)


## Combined comparison plot
p_compare <- ggplot() +
  geom_line(data = historical, aes(x = date, y = rate), color = "steelblue", linewidth = 1) +
  geom_point(data = daily, aes(x = Date, y = end_rate), color = "red", size = 2) +
  labs(
    title = "USD/MXN Exchange Rate: Historical vs Most Recent Daily",
    x = "Date",
    y = "Rate"
  ) +
  theme_minimal(base_size = 14)

ggsave("plots/comparison_plot.png", p_compare, width = 10, height = 6)

