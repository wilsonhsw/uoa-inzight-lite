# ----------------------------------------
#
# This image inherits uoa-inzight-lite-base image,
# updates packages from docker.stat.auckland.ac.nz
# repository and installs the shiny app for Lite
#
# ----------------------------------------
#FROM scienceis/uoa-inzight-lite-base:latest
FROM uoa-inzight-lite-base:tom

MAINTAINER "Science IS Team" ws@sit.auckland.ac.nz

# Update the packages hosted on docker.stat;
# download latest Lite app and put in place
RUN R -e "update.packages(repos = 'http://docker.stat.auckland.ac.nz/R')" \
  && rm -rf /srv/shiny-server/* \
  && wget --no-verbose -O Lite.zip https://github.com/iNZightVIT/Lite/archive/master.zip \
  && unzip Lite.zip \
  && cp -R Lite-master/* /srv/shiny-server \
  && rm -rf Lite.zip Lite-master/ \
  && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
