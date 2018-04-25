# ----------------------------------------
#
# This image inherits uoa-inzight-lite-base image, 
# updates packages from docker.stat.auckland.ac.nz 
# repository and installs the shiny app for Lite
#
# ----------------------------------------
FROM scienceis/uoa-inzight-lite-base:dev

MAINTAINER "Science IS Team" ws@sit.auckland.ac.nz

# Edit the following environment variable, commit to Github and it will trigger Docker build
# Since we fetch the latest changes from the associated Application~s master branch
# this helps trigger date based build
# The other option would be to tag git builds and refer to the latest tag
ENV LAST_BUILD_DATE "Sun 12 11 23:45:00 NZDT 2017"

# Install (via R) all of the necessary packages (R will automatially install dependencies):
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 381BA480 \
    && echo "deb http://deb.debian.org/debian stretch main" | sudo tee -a /etc/apt/sources.list \
    && apt-get update -y -q \
    && apt-get install -y -q \
                       libxml2-dev \
                       default-jdk \
                       libcurl4-openssl-dev \
                       libcairo2-dev \
                       libv8-3.14-dev \
                       libgdal-dev \
                       libproj-dev \
                       libprotobuf-dev \
                       protobuf-compiler \
                       libudunits2-dev \
                       libgeos-dev \
                       libpq-dev \
                       libjq-dev \
    && apt-get install -y -q \ 
                       software-properties-common \
    && add-apt-repository ppa:jonathonf/gcc-7.1 \

    && apt-get update -y -q \
    && apt-get install gcc-7 g++-7 \
    && update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-7 60 --slave /usr/bin/g++ g++ /usr/bin/g++-7 \

#    && update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.9 50 \ 
#    && update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-4.9 50 \
#    && update-alternatives --install /usr/bin/cc cc /usr/bin/gcc 60 \
#    && update-alternatives --set cc /usr/bin/gcc \
#    && update-alternatives --install /usr/bin/c++ c++ /usr/bin/g++ 60 \
#    && update-alternatives --set c++ /usr/bin/g++ \
#    && update-alternatives --config gcc \
#    && update-alternatives --config g++ \

#    && apt-get update -y -q \
#    && apt-get upgrade -y -q \
    
  && R -e "install.packages('devtools', repos = 'https://cran.r-project.org', type = 'source', dependencies = TRUE); devtools::install_github('r-spatial/sf'); devtools::install_github('daniel-barnett/ggsfextra'); devtools::install_github('iNZightVIT/iNZightMaps@dev')" \
  && rm -rf /srv/shiny-server/* \
  && wget --no-verbose -O Lite.zip https://github.com/iNZightVIT/Lite/archive/master.zip \
  && unzip Lite.zip \
  && cp -R Lite-master/* /srv/shiny-server \
  && echo $LAST_BUILD_DATE > /srv/shiny-server/build.txt \
  && rm -rf Lite.zip Lite-master/ \
  && rm -rf /tmp/* /var/tmp/*

# start shiny server process - it listens to port 3838
CMD ["/opt/shiny-server.sh"]
