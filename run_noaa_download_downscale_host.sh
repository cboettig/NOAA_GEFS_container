#!/usr/bin/env bash

 docker run --name noaa_download -v /Users/quinn/Downloads/GEFS_test:/data rqthomas/noaa_gefs_download_downscale bash /run_noaa_download_downscale.sh
 docker container rm noaa_download