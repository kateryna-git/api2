
# plumber.R

library(tidyverse)
library(lubridate)
library(jsonlite)
library(modeltime)
library(timetk) 


raw_data <- read_csv("sales_data_sample.csv") 


#* Plot a time series plot of the data
#* @serializer htmlwidget
#* @get /plot
plot <- function() {
  raw_data %>%
    select(SALES, ORDERDATE) %>% 
    mutate(date = mdy_hm(ORDERDATE) %>% as_datetime()) %>%
    group_by(date) %>%
    summarise(value = sum(SALES)) %>%
    ungroup() %>%
    plot_time_series(date, value, .interactive = TRUE)

}



#* Returns filtered data
#* @param forecast_period Forcast period in months
#* @param time_unit Unit to aggregate by (month, day, week, year)
#* @param left date range lower margin
#* @param right date range upper margin 
#* @serializer json
#* @post /raw_data

function(forecast_period = "6 months", time_unit = "day", left = "2003-01-06", right = "2005-05-31") {
  
raw_data %>%    
    select(SALES, ORDERDATE) %>% 
    mutate(date = mdy_hm(ORDERDATE) %>% as_datetime()) %>% 
    filter(date %>% between(as_datetime(left),
                            as_datetime(right))) %>% 
    mutate(date = floor_date(date,  # Round dates to beginning of a period
                             unit = time_unit)) %>% 
    group_by(date) %>%
    summarise(value = sum(SALES)) %>%
    ungroup()
  
}

