FROM mdancho/h2o-plumber:latest

RUN ["install2.r", "jsonlite", "modeltime", "timetk"]

COPY plumber.R /plumber.R
COPY sales_data_sample.csv /sales_data_sample.csv

CMD ["/plumber.R"]
