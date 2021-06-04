library(raster)

source("~./func.R")


## Digital Elevation Model (with SRTM voids filled using accurate topographic mapping) 
## available from Jonathan de Ferranti (http://www.viewfinderpanoramas.org/dem3.html)

## load DEMs and merge into single RasterLayer
d <- list.dirs("~/Downloads/DEM", recursive = FALSE)

DEM <- Reduce(raster::merge, lapply(d, function(x) {
  combine_rasters(d = x) }))

## calculate slope from DEM RasterLayer
slope <- raster::terrain(DEM, opt = "slope", unit = "radians")

#coarsen the resolution of the DEM 
aggr <- raster::resample(slope_raster, pacific_coast)

slope_aggr <- raster::extract(aggr, pacific_coast_df, df = TRUE)
slope_aggr$x <- pacific_coast_df$x
slope_aggr$y <- pacific_coast_df$y
slope_aggr <- slope_aggr[,2:4]


writeRaster(slope_aggr, filename = "slope.grd")


