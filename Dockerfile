 FROM rstudio/plumber

RUN apt-get update && apt-get install -y --no-install-recommends apt-utils
RUN apt-get install -y --no-install-recommends libxt6

## Install R Packages
RUN R -e "install.packages('tidyverse')"
RUN R -e "install.packages('lubridate')"
RUN R -e "install.packages('jsonlite')"
RUN R -e "install.packages('modeltime')"
RUN R -e "install.packages('timetk')"

COPY plumber.R /plumber.R
COPY sales_data_sample.csv /sales_data_sample.csv

CMD ["/plumber.R"]
