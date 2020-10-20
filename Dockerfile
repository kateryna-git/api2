 FROM rstudio/plumber

RUN apt-get update && apt-get install -y --no-install-recommends apt-utils
RUN apt-get install -y --no-install-recommends libxt6


RUN apt-get update && apt-get install -y \
    sudo \
    gdebi-core \
    pandoc \
    pandoc-citeproc \
    libcurl4-gnutls-dev \
    libcairo2-dev \
    libxt-dev \
    xtail \
    wget



## Install R Packages
RUN R -e "install.packages('tidyverse')"
RUN R -e "install.packages('modeltime')"
RUN R -e "install.packages('timetk')"
RUN R -e "install.packages('recipes')"

# copy everything from the current directory into the container
COPY / /

# open port 80 to traffic
EXPOSE 8000

# when the container starts, start the main.R script
ENTRYPOINT ["Rscript", "main.R"]
