FROM rocker/r-ver:4.0.2

RUN export DEBIAN_FRONTEND=noninteractive;
RUN apt-get update && apt-get install -y --no-install-recommends apt-utils
RUN apt-get install -y --no-install-recommends libxt6


# install the linux libraries needed for plumber
RUN apt-get update -qq && apt-get install -y \
  libssl-dev \
  libcurl4-gnutls-dev

# install plumber
RUN R -e "install.packages('plumber')"
RUN R -e "install.packages('jsonlite')"
RUN R -e "install.packages('dplyr')"
RUN R -e "install.packages('magrittr')"
RUN R -e "install.packages('timetk')"
RUN R -e "install.packages('modeltime')"
RUN R -e "install.packages('plotly')"
RUN R -e "install.packages('lubridate')"
RUN R -e "install.packages('readr')"

# copy everything from the current directory into the container
COPY / /

# open port 80 to traffic
EXPOSE 8000

# when the container starts, start the main.R script
ENTRYPOINT ["Rscript", "plumber.R"]

