library(raster)




#load DEM raster data and merge to create map
#source of DEM: http://www.viewfinderpanoramas.org/

setwd("~/Downloads/K10")
files <- list.files("~/Downloads/K10", pattern = "*.hgt")

## for each files do action below
# J10 K10 L10 I10 J11 K11 L11 M10 M11
raster <- Reduce(raster::merge, lapply(files, raster))

## DEM for the Pacific Coast region of the United States
DEM <- merge(I10, J10, K10, L10, I11, J11, K11, L11, M10, M11)

writeRaster(slope, filename = "slope.grd")

slope <- raster("slope.grd")

## calculate slope from a DEM raster
slope <- raster::terrain(DEM, opt = "slope", unit = "radians")

#coarsen the resolution of the DEM 
aggr <- raster::resample(slope_raster, pacific_coast)

slope_aggr <- raster::extract(aggr, pacific_coast_df, df = TRUE)
slope_aggr$x <- pacific_coast_df$x
slope_aggr$y <- pacific_coast_df$y
slope_aggr <- slope_aggr[,2:4]





