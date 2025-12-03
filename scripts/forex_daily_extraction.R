# Final project for Data 330 
# Done by Trishelle Leal 

# Libraries
library(dplyr)
library(jsonlite)
library(lubridate)
library(ggplot2)


# TODAY'S OPEN-CLOSE Exchange rate
api_key <- Sys.getenv("API_KEY") # Not putting out my API on GH
ex_ret <- paste0("https://api.exchangerate.host/change?access_key=", api_key, "&currencies=MXN")
call <- fromJSON(ex_ret)

# Ordered file system
file <- "data/MXNUSD_ExchData.csv"


if (call$success) {
  new_row <- data.frame(
    Date = call$end_date,
    start_rate = call$quotes$USDMXN$start_rate,
    end_rate = call$quotes$USDMXN$end_rate, 
    # End rate refers to the rate at the time retrieved, since we retrieve at 5 ET, it basically is the rate at close
    change = call$quotes$USDMXN$change # Change during the day
  )
  
  if (!file.exists(file)) {
    write.csv(new_row, file, row.names = FALSE)
  } else {
    write.table(new_row, file, sep = ",", col.names = FALSE,
                row.names = FALSE, append = TRUE)
  }
}


## HISTORICAL RETRIEVING
api_key2 <- Sys.getenv("API_KEY2")
today <- Sys.Date()
md <- format(today, "%m-%d")

# Creates folder if not there, otherwise does nothing (only does something on the first run)
dir.create("data/historical", showWarnings = FALSE, recursive = TRUE)

# File to output
hist_csv_file <- paste0("data/historical/USDMXN_", md, ".csv")

# If we have already searched through this date, we only append a new row
# Otherwise we search through the last 5 years to see the changes.
if (!file.exists(hist_csv_file)) {
  all_hist <- list()
  for (year in 1:5) {
    date_i <- today %m-% years(year)
    date_str <- format(date_i, "%Y-%m-%d")
    
    hist_url <- paste0(
      "http://api.exchangeratesapi.io/v1/", date_str,
      "?access_key=", api_key2,
      "&symbols=USD,MXN&format=1"
    )
    
    callh <- fromJSON(hist_url)
    
    if (callh$success) {
      row <- data.frame(
        date = callh$date,
        rate = as.numeric(callh$rates$MXN) / as.numeric(callh$rates$USD)
      )
      all_hist[[length(all_hist) + 1]] <- row
    }
  }
  
  out <- bind_rows(all_hist)
  write.csv(out, hist_csv_file, row.names = FALSE)
  
} else {
  # If we had already gone through this date, we just look at today's data
  # Should happen from December 2nd, 2026 and forward. 
  hist_url <- paste0("http://api.exchangeratesapi.io/v1/", 
                     format(today, "%Y-%m-%d"), 
                     "?access_key=", api_key2,
                     "&symbols=USD,MXN&format=1")
  
  callh <- fromJSON(hist_url)
  
  if (callh$success) {
    toappend <- data.frame(
      date = callh$date,
      # API does not support non EU exchange rates so I got creative. 
      rate = as.numeric(callh$rates$MXN) / as.numeric(callh$rates$USD)
    )
    
    write.table(
      toappend,
      hist_csv_file,
      sep = ",",
      col.names = FALSE,
      row.names = FALSE,
      append = TRUE
    )
  }
}
