##' @title Script to launch NOAA download and temporal downscaling
##' @return None
## @param site_list, vector of site codes, used in directory and file name generation
##' @param lat_list, vector of latitudes that correspond to site codes
##' @param lon_list, vector of longitudes that correspond to site codes
##' @param output_directory, directory where the model output will be save
##' @param downscale, logical specifying whether to downscale from 6-hr to 1-hr
##' @param run_parallel, logical whether to run on multiple cores
##' @param num_cores, number of cores used if run_parallel == TRUE
##' @param overwrite, logical stating to overwrite any existing output_file

##' @export
##' @export
##' 
##' @author Quinn Thomas
##' 
##' 

noaa_gefs_download_downscale <- function(site_list,
                                         lat_list,
                                         lon_list,
                                         output_directory,
                                         downscale,
                                         run_parallel = FALSE,
                                         num_cores = 1, 
                                         overwrite = FALSE){

  library(rNOMADS)
  
  model_name <- "NOAAGEFS"
  model_name_ds <-"NOAAGEFStimeds" #Downscaled NOAA GEFS
  
  print(paste0("Number of sites: ", length(site_list)))
  print(paste0("Overwrite existing files: ", overwrite))
  print(paste0("Running in parallel: ", run_parallel))
  
  if(run_parallel){
    
    #Create cluster
    print(paste0("Number of cores specified: ", config_file$num_cores))
    if(num_cores > parallel::detectCores()){
      #Docker sets the max number of cores, if the request is for more, set to 
      #what docker allows
      num_cores <- parallel::detectCores()
      
    }
    print(paste0("Number of cores allocated: ", num_cores))
    
    
    site_index <- 1:length(site_list)
    
    #Run download_downscale_site() over the site_index
    parallel::mclapply(X = site_index, 
                       FUN = download_downscale_site, 
                       lat_list = lat_list,
                       lon_list = lon_list,
                       site_list = site_list,
                       downscale = downscale,
                       overwrite = overwrite,
                       model_name = model_name,
                       model_name_ds = model_name_ds, 
                       output_directory = output_directory, 
                       mc.cores = num_cores)
    
  }else{
    
    for(site_index in 1:length(site_list)){
      
      download_downscale_site(site_index,
                              lat_list = lat_list,
                              lon_list = lon_list,
                              site_list = site_list,
                              downscale = downscale,
                              overwrite = overwrite,
                              model_name = model_name,
                              model_name_ds = model_name_ds,
                              output_directory = output_directory)
    }
  }
}

