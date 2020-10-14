FROM rstudio/plumber

RUN ["install2.r", "dplyr", "forcats", "ggplot2", "jsonlite", "lubridate", "modeltime", "purrr", "readr", "remotes", "stringr", "tibble", "tidyr", "timetk"]
RUN ["installGithub.r", "tidyverse/tidyverse@8a0bb998e92fb61339d555f22d8bf7314c625700"]
