FROM rocker/r-ver:4.0.2

RUN apt-get update && apt-get install -y --no-install-recommends apt-utils
RUN apt-get install -y --no-install-recommends libxt6


RUN export DEBIAN_FRONTEND=noninteractive; apt-get -y update \
  && apt-get install -y git-core
RUN ["install2.r", "plumber",  "dplyr", "forcats", "ggplot2", "jsonlite", "lubridate", "modeltime", "purrr", "readr", "remotes", "stringr", "tibble", "tidyr", "timetk", "plotly"]



COPY plumber.R /plumber.R
RUN chmod +x plumber.R
COPY sales_data_sample.csv /sales_data_sample.csv

ENTRYPOINT ["/plumber.R"]
