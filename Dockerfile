FROM rocker/r-ver:4.0.2

RUN export DEBIAN_FRONTEND=noninteractive; apt-get -y update \
  && apt-get install -y git-core
RUN ["install2.r", "dplyr", "forcats", "ggplot2", "jsonlite", "lubridate", "modeltime", "purrr", "readr", "remotes", "stringr", "tibble", "tidyr", "timetk"]

COPY plumber.R /plumber.R
COPY sales_data_sample.csv /sales_data_sample.csv

CMD ["/plumber.R"]
