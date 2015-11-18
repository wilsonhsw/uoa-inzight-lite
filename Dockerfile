FROM scienceis/uoa-inzight-base:latest

MAINTAINER "Science IS Team" ws@sit.auckland.ac.nz

# install R packages specific to iNZight Lite
RUN rm -rf /srv/shiny-server/* \
  && git clone https://github.com/iNZightVIT/Lite.git \
  && rm -rf Lite/.git
  && cp -R Lite/* /srv/shiny-server
  && rm -rf Lite/

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# startup process
CMD ["sudo", "-u", "shiny", "/usr/bin/shiny-server"]
