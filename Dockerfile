FROM rocker/r-ver:4.0.2

RUN apt-get update && apt-get install -y --no-install-recommends apt-utils
RUN apt-get install -y --no-install-recommends libxt6

RUN apt-get update -qq && apt-get install -y \
  libssl-dev \
  libcurl4-gnutls-dev   
  
  
  RUN apt-get update -qq && apt-get -y --no-install-recommends install \
  libxml2-dev \            #for tydyverse
  libcairo2-dev \
  libsqlite-dev \
  libmariadbd-dev \
  libmariadbclient-dev \
  libpq-dev \
  libssh2-1-dev \
  unixodbc-dev \
  libsasl2-dev \
  && install2.r --error \
    --deps TRUE \
    tidyverse \
    dplyr \
    devtools \
    formatR \
    remotes \
    selectr \
    caTools \
    BiocManager \
    plumber \
    timetk \
    modeltime \
    plotly \
    lubridate
  
  

# install plumber
#RUN R -e "install.packages('plumber')"
#RUN R -e "install.packages('')"
#RUN R -e "install.packages('timetk')"
#RUN R -e "install.packages('modeltime')"
#RUN R -e "install.packages('plotly')"
#RUN R -e "install.packages('lubridate')"


# copy everything from the current directory into the container
COPY / /

# open port 80 to traffic
EXPOSE 8000

# when the container starts, start the main.R script
ENTRYPOINT ["Rscript", "plumber.R"]

