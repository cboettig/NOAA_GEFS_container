FROM rocker/tidyverse

# Install Dependencies
RUN apt-get -yq update && \
	apt-get -yqq install wget \
	git \
	libxml2-dev \
	libcurl4-openssl-dev \
	libssl-dev \
	netcdf-*\
	libnetcdf-dev\
	ssh && \
	R -e "install.packages(c('rNOMADS', 'RCurl', 'stringr', 'yaml','ncdf4', 'humidity'))" && \
	wget -O /usr/bin/yq https://github.com/mikefarah/yq/releases/download/3.2.1/yq_linux_amd64 
	
RUN mkdir /noaa 

COPY NOAA_GEFS_download_downscale.R /noaa/NOAA_GEFS_download_downscale.R
COPY temporal_downscaling.R /noaa/temporal_downscaling.R
COPY write_noaa_gefs_netcdf.R /noaa/write_noaa_gefs_netcdf.R
COPY rNOMADS_2.5.0.tar.gz /noaa/rNOMADS_2.5.0.tar.gz
\
# Get flare-container.sh
RUN R -e "install.packages("/noaa/rNOMADS_2.5.0.tar.gz", repos = NULL, type="source")" 
	
#create directory where output directory will be created	
RUN mkdir /data