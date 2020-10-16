FROM rocker/tidyverse:latest

RUN apt-get update && apt-get install -y --no-install-recommends apt-utils
RUN apt-get install -y --no-install-recommends libxt6


# install the linux libraries needed for plumber
RUN apt-get update -qq && apt-get install -y \
  libssl-dev \
  libcurl4-gnutls-dev
  
RUN R -e "install.packages('plumber')"
RUN R -e "install.packages('timetk')"
RUN R -e "install.packages('modeltime')"
RUN R -e "install.packages('plotly')"
  
  

# copy everything from the current directory into the container
COPY / /

# open port 80 to traffic
EXPOSE 8000

ENTRYPOINT ["R", "-e", "pr <- plumber::plumb(commandArgs()[4]); pr$run(host='0.0.0.0', port=8000)"]

# when the container starts, start the main.R script
CMD ["Rscript", "plumber.R"]

