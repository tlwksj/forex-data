# Final project for Data 330 
# Done by Trishelle Leal 

# Script to scrape and download data

# Libraries to load
library(dplyr)
library(jsonlite)
library(ggplot2)


api_key <-  Sys.getenv("API_KEY")

# Link to retrieve historical data 
date <- "placeholder"
historical_ret <- paste0("https://api.exchangerate.host/historical?date=", date)

# Retrieves the exchange rate information
ex_ret <-  paste0("https://api.exchangerate.host/change?access_key=",api_key,"&currencies=MXN")
call <- fromJSON(ex_ret)

# CSV to output. 
file <- "data/MXNUSD_ExchData.csv"

# Only continues if the call was successful (Avoids unnecessary emails.)
if (call$success){
  # Creating data frame
  new_row <- data.frame(
    Date = call$end_date,
    start_rate = call$quotes$USDMXN$start_rate,
    end_rate = call$quotes$USDMXN$end_rate,
    change = call$quotes$USDMXN$change
  )
  # Creating the output csv
  if (!file.exists(file)) {
    # Should only occur on the first run
    write.csv(new_row, file, row.names = FALSE)
  } else {
    write.table(
      new_row,
      file,
      sep = ",",
      col.names = FALSE,
      row.names = FALSE,
      append = TRUE
    )
  }
}
