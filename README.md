Automated Currency Monitoring & Visualization Pipeline     
Data 330 – Final Project     
Author: Trishelle Leal     

The project follows through the complete data wrangling pipeline by automatically collecting, processing, and creating visualizations currency exchange rate data between the US dollar and the mexican peso using scheduled tasks, multiple APIs and R-based scripts. The full pipeline starts running daily at 5:00 PM EST, time when the market closes, retrieving the latest USD/MXN exchange rate, cleaning it, and generating refreshed visualizations.

**Project motivation**
Growing up on the border between the US and Mexico, it is often that you see others tracking the exchange rate to be able to determine when it is best to buy dollars using their pesos. With this project, they could determine what days of the week or what seasons of the year the dollar drops and when it is best to buy or sell the currency. This project would be deemed beneficial by many, as it would automate the data search and having visualizations would make it easier to understand how today's rate compares to tomorrow's. 

**Project Components**

1. Scripts          
   The scripts used for this project all live within this folder, this done with the intention of maintaining the repository completely organized and well-managed.

   a. Data extraction script (forex_daily_extraction.R)         
   This script makes calls to two different APIs to collect the forex data for today's date, one of them focusing on the historical data, and the other uniquely on the current date. Both write onto a CSV in order to set the scene for the rest of the workflow.

   **Data Sources:**      
     a. ExchangeRate.host     
       This source was used for the retrieval of the current exchange rate.    
     b. ExchangeratesAPI.io    
       This is the source used for the historical data.  

   Both sources provide the data in JSON format, which facilitated the cleaning process. The script holds two functions one that facilitates the conversion from EU rates to usd/mxn rates and the second to aid the writing onto a CSV file. For the historical part, the script verifies that the CSV file for the date has not been created, and then proceeds to extract the last 5 years of data for the given date. In case that the date has been extracted (which would occur once this repository is at least a year old), the script only extracts the current date's data and appends it to the CSV, with the purpose of adding onto the historical file. For the historical data, every date in the calendar has its own file, making sure that the data is easy to find and append to.

    b. Data cleaning script (clean_data.R)     
    This is a simple script that takes the newly updated script, cleans it (in case of a badly formatted response that was not caught by the extracting script), and writes it again to be used by the visualization script. 

    c. Data Visualization script (forex_daily_visualization.R)    
    This script takes charge of creating visual aide for understanding the data extracted, and for further analysis. The script itself creates three visualizations, all seeking to have a different viewpoint on the data extracted.

    **Visualizations**
     1. Weekly rates vs. Today's rate:
        This visualization is a line graph of the last 7 days, showing the variance in the exchange rate for the past week. A colored point was added for today's date, said point's color changes depending on whether the rate today was higher or lower than yesterday.
     2. Today, in the past plot:
        This visualization is a line graph of today's date but in the past 5 years, it shows the variance between the same season/date in the last 5 years.
     3. Weekly rate vs Historical rate:
        This visualization is a visual comparison of the last two graphs. Providing the last 5 years of datam with a focus point on the post recent rate. 

   
