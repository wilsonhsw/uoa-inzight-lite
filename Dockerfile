FROM scienceis/uoa-inzight-base:latest

MAINTAINER "Science IS Team" ws@sit.auckland.ac.nz

# install R packages specific to iNZight Lite
RUN apt-get update \
  && rm -rf /srv/shiny-server/* \
  && wget -O Lite.zip https://github.com/iNZightVIT/Lite/archive/master.zip \
  && unzip Lite.zip \
  && cp -R Lite-master/* /srv/shiny-server \
  && rm -rf Lite-master/ \
  && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# copy shiny-server startup script
COPY shiny-server.sh /usr/bin/shiny-server.sh

# make it executable
RUN chmod +x /usr/bin/shiny-server.sh

# startup process
CMD ["/usr/bin/shiny-server.sh"]
