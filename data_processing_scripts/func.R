library(raster)
library(zoo)
library(data.table)
library(tidyverse)


## FUNCTIONS


## EXTRACT PRECIP FROM RAW NetCDF DATA (e.g., from PRISM)
extract_precip <- function(files, extent_raster, extent_df) {
  ## INPUTS:
  ## files = vector of filenames to read
  ## extent_raster = raster of study area
  ## extent_df = dataframe of x/y coordinates in study area (must be at same resolution as raster)
  ## RETURNS: list of matrices of daily precip for each year 
  precip_brick <- raster::brick(files)
  precip_brick_crop <- raster::crop(precip_brick, extent_raster)
  precip <- raster::extract(precip_brick_crop, extent_df, method = "simple", df = TRUE, cellnumbers = TRUE)
  precip <- precip[,-c(1:2)]
  return(precip)
}


## CENTER X/Y COORDINATES IN A DATAFRAME ON GRID CELLS IN RASTER
match_xy_to_raster <- function(df, raster) {
  ## INPUTS:
  ## df = x/y coordinates in first two columns of df
  ## raster = raster with same resolution, extent, and CRS as df 
  ## RETRUNS: dataframe of x/y coordinates centered on raster grid cells
  data_xy <- as.data.frame(df[, 1:2])
  data_cell <- cellFromXY(raster, data_xy)
  data_xy_match <- xyFromCell(raster, data_cell)
  data_xy_match <- as.data.frame(data_xy_match)
  return(data_xy_match)
}



## CALCULATE REGIONAL DAILY-SCALE CUMULATIVE ANTECEDENT PRECIPITATION
## (in this case for the Pacific Coast region between 2010 and 2017)
calculate_cumulative_precip <- function(i) {
  ## INPUTS: 
  ## i = list of durations of cumuative antecedent precipitation 
  ## RETURNS: vector for each duration (i) of cumulative antecedent precip
  cumulative_precip <- t(apply(pacific_coast_2009_2017[, 1:3287], 1, 
                                              FUN = rollsum, k = i, align = "right", fill = NA))
  cumulative_precip <- as.data.frame(cumulative_precip)
  cumulative_precip <- cumulative_precip[, 366:3287]
  cumulative_precip <- data.table::setnames(cumulative_precip, dates_2010_to_2017)
  cumulative_precip$x <- pacific_coast_df$x
  cumulative_precip$y <- pacific_coast_df$y
  cumulative_precip <- as.data.frame(cumulative_precip %>%
                                                      tidyr::gather(key = date, value = precip, -x , -y))
  print(i)
  return(cumulative_precip$precip)
}


## calc_antecedent_precip calculates precipitation preceding observed landslides 
## the function extracts precipitation amounts from a precip_df, 
## a dataframe of precipitation values, where the column names are date and rows represent lat/long values
## dates should be in character to format 

## QUANTIFY CUMULATIVE ANTECENT PRECIPITATION INTENSITY AT LANDSLIDES
calc_antecedent_precip <- function(precip_df) {
  ## INPUTS:
  ## precip_df = 
  ## RETURNS: 
  date_all <- precip_df[, date]
  date_all$x <- pacific_coast_df$x
  date_all$y <- pacific_coast_df$y
  date_all_xy <- right_join(date_all, inventory_xy_match, by = c("x", "y"))
  date_no_xy <- as.matrix(date_all_xy[,1:720])
  landslide_precip <- diag(date_no_xy)
  return(landslide_precip) 
}



