library(raster)
library(tidyverse)
library(ncdf4)
library(zoo)
library(data.table)

## daily 4 km precipitation data for the US is available from the PRISM Climate Group
## https://prism.oregonstate.edu 
source("./func.R")
setwd("~/Downloads/PRISM")

## list NetCDF files in folder containing raw daily precipitation data (in this case from PRISM)
## each file contains a year of daily data
files = list.files("~/Downloads/PRISM", pattern = "*.nc")

## extract daily precipitation data for Pacific Coast states for all files (i.e., years) in folder
daily_precip_2009_2017 <- lapply(files, function(x) {
  extract_precip(filename = x, extent_raster = pacific_coast, extent_df = pacific_coast_df) } )

daily_precip_2009_2017 <- as.data.frame(daily_precip_2009_2017)

dates_2009_to_2017 <- seq(from = as.Date("2009/1/1"), to = as.Date("2017/12/31"), by = "day")
dates_2009_to_2017 <- as.character(dates_2009_to_2017)

daily_precip_2009_2017 <- data.table::setnames(daily_precip_2009_2017, dates_2009_to_2017)
daily_precip_2009_2017$x <- pacific_coast_df$x
daily_precip_2009_2017$y <- pacific_coast_df$y

## make a list of periods (i.e., durations) of antecedent precipitation accumulation
antecedent_days <- c(10, 30)

## calculate precipitation accumulation periods
cumulative_precip <- lapply(antecedent_days, function(x) {
  calculate_cumulative_precip(i = x) } )

cumulative_precip_df <- as.data.frame(t(do.call(rbind, cumulative_precip)))
names(cumulative_precip_df) <- c("precip_10d", "precip_30d")


precip_1d <- as.data.frame(daily_precip_2010_2017 %>%
                                  tidyr::gather(key = date, value = precip_1d, -x , -y))

precip_df <- cbind(precip_1d, cumulative_precip_df)


