library(rgdal)
library(raster)
library(tidyverse)

source("./func.R")

## read in raster and dataframe of the study area (in this case, the Pacific Coast region of the coterminous US)
pacific_coast <- raster("./pacific_coast.asc")
crs(pacific_coast) <- "+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0" 
pacific_coast_df <- readRDS("./pacific_coast_df.rds")
land_use <- readRDS("./land_use.rds")

## The TIGER/Line shapefile of land use designations is available from the US Census (http://data.census.gov)
## Read in the latest TIGER/Line shapefile for the US as a SpatialPolygonsDataFrame
us_tiger_lines <- rgdal::readOGR("tl_2017_us_uac10", "tl_2017_us_uac10")

## crop the SpatialPolygonsDataFrame to the rectangular spatial extent of interest 
pacific_coast_tiger_lines <- raster::crop(us_tiger_lines, pacific_coast_df)

## turn the SpatialPolygonsDataFrame into a dataframe
pacific_coast_tiger_lines@data$id <- rownames(pacific_coast_tiger_lines@data)
pacific_coast_tiger_lines_points <- ggplot2::fortify(pacific_coast_tiger_lines, region = "id")
pacific_coast_tiger_lines_df <- merge(pacific_coast_tiger_lines_points, pacific_coast_tiger_lines@data, by = "id")
pacific_coast_tiger_lines_df <- plyr::rename(pacific_coast_tiger_lines_df, replace = c("long" = "x", "lat" = "y"))

## ensure that the center of the grid cells of this new dataframe match those of the raster of our study area
pacific_coast_tiger_lines_df_xy_match <- match_xy_to_raster(data = pacific_coast_tiger_lines_df[,2:3], raster = pacific_coast)
pacific_coast_tiger_lines_df$x <- pacific_coast_tiger_lines_df_xy_match$x
pacific_coast_tiger_lines_df$y <- pacific_coast_tiger_lines_df_xy_match$y

pacific_coast_tiger_lines_df <- pacific_coast_tiger_lines_df %>%
  distinct(x, y, .keep_all = TRUE)

## exclude grid cells not in the Pacific Coast region (i.e, go from a rectangular spatial extent to the outline of the Pacific Coast region)
pacific_coast_tiger_lines_df <- left_join(pacific_coast_df, pacific_coast_tiger_lines_df, by = c("x", "y"))
urban_footprint_df <- pacific_coast_tiger_lines_df[,c(1, 2, 14)]


## rasterize the urban footprint dataframe
coordinates(urban_footprint_df) <- ~ x + y
gridded(urban_footprint_df) <- TRUE
urban_footprint_raster <- raster(urban_footprint_df)

## for all rural areas in the study area, calculate the distance to an urban area and/or urban cluster
calc_distance_to_footprint <- distance(urban_footprint_raster)
distance_to_footprint <- raster::extract(calc_distance_to_footprint, pacific_coast_df, method = "simple", df = TRUE)
distance_to_footprint$x <- pacific_coast$x
distance_to_footprint$y <- pacific_coast$y
distance_to_footprint <- distance_to_footprint[,2:4]
distance_to_footprint <- plyr::rename(distance_to_footprint, replace = c("layer" = "distance_to_footprint"))

## convert from meters to kilometers
distance_to_footprint$distance_to_footprint <- distance_to_footprint$distance_to_footprint/1000 

## reclassify rural areas based on proximity to urban footprint 
distance_to_footprint$land_use <- land_use$classification
distance_to_footprint_rural <- distance_to_footprint %>% filter(land_use == "rural")

distance_to_footprint_less_than_10 <- distance_to_footprint_rural %>% filter(distance_to_footprint < 10)
distance_to_footprint_less_than_10$land_use_subdiv <- rep("rural_less_than_10", nrow(distance_to_footprint_less_than_10))

distance_to_footprint_less_than_50 <- distance_to_footprint_rural %>% filter(distance_to_footprint < 50, distance_to_footprint >= 10)
distance_to_footprint_less_than_50$land_use_subdiv <- rep("rural_less_than_50", nrow(distance_to_footprint_less_than_50))

distance_to_footprint_greater_than_50 <- distance_to_footprint_rural %>% filter(distance_to_footprint >= 50)
distance_to_footprint_greater_than_50$land_use_subdiv <- rep("rural_greater_than_50", nrow(distance_to_footprint_greater_than_50))

urban <- distance_to_footprint %>% filter(land_use == "urbanized")
urban$land_use_subdiv <- rep("urbanized", nrow(urban))

urban_cluster <- distance_to_footprint %>% filter(land_use == "urban_cluster")
urban_cluster$land_use_subdiv <- rep("urban_cluster", nrow(urban_cluster))

## combine to form new dataframe of land_use with rural areas subdivided 
land_use_subdiv <- rbind(distance_to_footprint_less_than_10, 
                         distance_to_footprint_less_than_50,
                         distance_to_footprint_greater_than_50,
                         urban, 
                         urban_cluster)

land_use_subdiv <- land_use_subdiv[, c(2:3, 5)]




