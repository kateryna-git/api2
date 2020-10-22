
# plumber.R
library(plumber)
library(tidyverse)
library(lubridate)
library(jsonlite)
library(modeltime)
library(timetk) 
library(recipes) 

# MAIN FUNCTION ----

get_sales_data <- function(forecast_period = "6 months", time_unit = "day", left = "2003-01-06", right = "2005-05-31") {
  
  raw_data <- read_csv("sales_data_sample.csv")  #read only the needed fields to make faster
  
  preped_table <- raw_data %>%    
    select(SALES, ORDERDATE) %>% 
    mutate(date = mdy_hm(ORDERDATE) %>% as_datetime()) %>% 
    filter(date %>% between(as_datetime(left),
                            as_datetime(right))) %>% 
    mutate(date = floor_date(date,  # Round dates to beginning of a period
                             unit = time_unit)) %>% 
    group_by(date) %>%
    summarise(value = sum(SALES))
  
  return(preped_table)
}



get_predictions <- function(forecast_period = "6 months", time_unit = "day", left = "2003-01-06", right = "2005-05-31") {
  
  #load model
  MODEL <- read_rds("model-prophet-boost.rds")
  
  predictions <- MODEL %>% 
    modeltime_refit(get_sales_data(forecast_period, time_unit, left, right) %>% ungroup()) %>%
    modeltime_forecast(h = forecast_period, actual_data = get_sales_data(forecast_period, time_unit, left, right) %>%
                         ungroup())
  
  return(predictions)
  
}


### END POINTS ----


#* @apiTitle Plumber Sales Analysis API


#* Returns filtered data
#* @param forecast_period Forcast period in months
#* @param time_unit Unit to aggregate by (month, day, week, year)
#* @param left date range lower margin
#* @param right date range upper margin 
#* @serializer json
#* @post /raw_data

function(forecast_period = "6 months", time_unit = "day", left = "2003-01-06", right = "2005-05-31") {
  
  get_sales_data(forecast_period, time_unit, left, right)
  
}

#* Plot a time series plot of the data
#* @serializer htmlwidget
#* @get /plot
function() {
  
  sales_data <- get_sales_data(forecast_period, time_unit, left, right)
  sales_data %>%
    ungroup() %>%
    plot_time_series(date, value, .interactive = TRUE)
}



# PREDICTIONS ----

#* Returns predictions
#* @param forecast_period Forcast period in months
#* @param time_unit Unit to aggregate by (month, day, week, year)
#* @param left date range lower margin
#* @param right date range upper margin 
#* @serializer json
#* @post /predict
function(forecast_period = "6 months", time_unit = "day", left = "2003-01-06", right = "2005-05-31") { 
  
  predictions <- get_predictions(forecast_period, time_unit, left, right)
  
  pred_table <- predictions %>%
    mutate(.index = floor_date(.index,  # Round dates to beginning of a period
                             unit = time_unit)) %>%
    group_by(.index) %>%
    summarise(
              .index = .index, 
              .value = sum(.value), 
              .conf_lo = mean(.conf_lo), 
              .conf_hi = mean(.conf_hi)) %>% 
    unique()
  
  return(pred_table)

}

#* Plot a time series plot of the data
#* @serializer htmlwidget
#* @get /predict_plot
function() { 
  
  get_predictions() %>%
    plot_modeltime_forecast(.interactive = TRUE)
  
}
