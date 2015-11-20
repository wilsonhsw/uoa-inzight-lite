FROM scienceis/uoa-inzight-base:latest

MAINTAINER "Science IS Team" ws@sit.auckland.ac.nz

# Install (via R) all of the necessary packages (R will automatially install dependencies):
RUN R -e "update.packages(repos = 'http://docker.stat.auckland.ac.nz/R')" \
  && R -e "install.packages(\
             c('iNZightMR', 'iNZightTS', 'iNZightRegression', 'iNZightPlots', 'GGally'), \
             repos = c('http://docker.stat.auckland.ac.nz/R', 'http://cran.stat.auckland.ac.nz') \
           )" \
  && rm -rf /srv/shiny-server/* \
  && wget --no-verbose -O Lite.zip https://github.com/iNZightVIT/Lite/archive/master.zip \
  && unzip Lite.zip \
  && cp -R Lite-master/* /srv/shiny-server \
  && rm -rf Lite.zip Lite-master/ \
  && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# copy shiny-server startup script
COPY shiny-server.sh /usr/bin/shiny-server.sh

# make it executable
RUN chmod +x /usr/bin/shiny-server.sh

# startup process
CMD ["/usr/bin/shiny-server.sh"]
