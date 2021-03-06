FROM rocker/tidyverse

# Install Dependencies
RUN apt-get -yq update && \
	apt-get -yqq install wget \
	git \
	libxml2-dev \
	libcurl4-openssl-dev \
	libssl-dev \
	netcdf-* \
	libudunits2-dev \
	libnetcdf-dev \
	ssh && \
	R -e "install.packages(c('rNOMADS', 'RCurl', 'stringr', 'yaml','ncdf4', 'humidity', 'udunits2','yaml'))" && \
	wget -O /usr/bin/yq https://github.com/mikefarah/yq/releases/download/3.2.1/yq_linux_amd64 
	
RUN mkdir -p /noaa 
RUN mkdir -p /noaa/R

COPY launch_download_downscale.R /noaa/launch_download_downscale.R
COPY R/temporal_downscaling.R /noaa/R/temporal_downscaling.R
COPY R/write_noaa_gefs_netcdf.R /noaa/R/write_noaa_gefs_netcdf.R
COPY R/download_downscale_site.R /noaa/R/download_downscale_site.R
COPY R/noaa_gefs_download_downscale.R /noaa/R/noaa_gefs_download_downscale.R
COPY R/rNOMADS_2.5.0.tar.gz /noaa/R/rNOMADS_2.5.0.tar.gz
COPY run_noaa_download_downscale.sh /run_noaa_download_downscale.sh

# Get flare-container.sh
RUN R -e "install.packages('/noaa/R/rNOMADS_2.5.0.tar.gz', repos = NULL)" 
	
#create directory where output directory will be created	
RUN mkdir -p /noaa/data
#create directory where configuration files will be located
RUN mkdir -p /noaa/config