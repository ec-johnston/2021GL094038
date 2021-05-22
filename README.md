# GRL2021
## Supporting code for manuscript submitted to GRL: "Quantifying the influence of precipitation intensity on landslide hazard in urbanized and non-urbanized areas"

Elizabeth C. Johnston (1), Frances V. Davenport (1), Lijing Wang (2), Jef K. Caers (2,3), Suresh Muthukrishnan (4,5), Marshall Burke (1,6,7) and Noah S. Diffenbaugh (1,8)

1. Department of Earth System Science, Stanford University, Stanford, CA 94305
2. Department of Geological Sciences, Stanford University, Stanford, CA 94305
3. Institute for Human-Centered Artificial Intelligence, Stanford University, Stanford, CA 94305
4. Department of Earth, Environmental, and Sustainability Sciences, Furman University, Greenville, SC 29613
5. GIS and Remote Sensing Center, Furman University, Greenville, SC 29613
6. Center on Food Security and the Environment, Stanford University, Stanford, CA 94305
7. Environment and Energy Economics, National Bureau of Economic Research, Cambridge, MA 02138
8. Woods Institute for the Environment, Stanford University, Stanford, CA 94305


Corresponding author: Elizabeth C. Johnston (ecj@stanford.edu)

Raw datasets are available from the following locations: 

- PRISM daily 4km precipitation: available from the PRISM Climate Group, Oregon State University (http://www.prism.oregonstate.edu)
- Digital Elevation Model – with SRTM voids filled using accurate topographic mapping – is available from Jonathan de Ferranti (http://www.viewfinderpanoramas.org/dem3.html)
- The Cooperative Open Online Landslide Repository is available from NASA (https://landslides.nasa.gov)
- The TIGER/Line shapefile of land use designations is available from the US Census (http://data.census.gov)

## Organization of Repository
 
- data_processing_scripts: code for processing raw data
- data: post-processed data
- analysis_scripts: code that analyzes data
- results: output from analysis_scripts

## data_processing_scripts

The following scripts process raw data:

- func.R: defines functions used throughout data processing and analysis
- calc-cumulative-precip.R: calculates up to thirty-day cumulative precipitation intensity from PRISM data
- calc-slope.R: calculates 4km slope from a 3 arc second digital elevation model (DEM)
- buffer-rural.R: subdivides rural areas based on proximity to urbanized areas and urban clusters

## reduced_data

Processed data for the US Pacific Coast region at 4 km spatial resolution (some processed data not included due to size): 

- pacific_coast_df.rds: dataframe of x/y coordinates within the Pacific Coast region at 4km resolution 
- pacific_coast.asc: raster layer of the Pacific Coast region at 4 km resolution 
- daily_precip_2010_2017.rds: daily precipitation data from PRISM 
- land_use.rds: land use designation into urbanized (>50,000 people), urban cluster (2,500 – 50,000 people), and rural (<2,500 people)  
- land_use_subdiv.rds: land use classification with rural areas subdivided based on proximity to urban footprint
- slope.rds: slope (in radians)
- landslides_precip.rds: daily to monthly antecedent precipitation intensity preceding observed landslides


## analysis_scripts

Scripts for panel regression models:

- panel_regression_models.R:
- bootstrap_models.R: 

## results

Bootstrapped coefficients from panel regression models

### pacific_coast
fit with data for the US Pacific Coast region 
- pacific_coast_daily_eq1.rds: results of Eq. 1 using daily precipitation intensity 
- pacific_coast_ten_day_eq1.rds: results of Eq. 1 using ten-day antecedent precipitation intensity 
- pacific_coast_monthly_eq1.rds: results of Eq. 1 using monthly antecedent precipitation intensity
- pacific_coast_daily_eq1_rural_subdiv.rds: results of Eq. 1 using daily precipitation intensity with rural areas subdivided based on proximity to the urban footprint
- pacific_coast_ten_day_eq1_rural_subdiv.rds: results of Eq. 1 using ten-day antecedent precipitation intensity with rural areas subdivided based on proximity to the urban footprint
- pacific_coast_monthly_eq1_rural_subdiv.rds: results of Eq. 1 using monthly antecedent precipitation intensity with rural areas subdivided based on proximity to the urban footprint
- pacific_coast_daily_eq2.rds: results of Eq. 2 (which considers an interaction with mean precipitation intensity) using daily precipitation intensity
- pacific_coast_daily_eq3.rds: results of Eq. 3 (which considers an interaction with mean slope) using daily precipitation intensity
- pacific_coast_daily_eq4.rds: results of Eq. 4 (which considers interactions with both mean precipitation and mean slope) using daily precipitation intensity

### bay_area
fit with data for coastal counties within the San Francisco Bay Area (i.e., Marin, San Francisco, San Mateo, and Santa Cruz counties)
- bay_area_daily_eq1.rds: results of Eq. 1 using daily precipitation intensity 
- bay_area_ten_day_eq1.rds: results of Eq. 1 using ten-day antecedent precipitation intensity 
- bay_area_monthly_eq1.rds: results of Eq. 1 using monthly antecedent precipitation intensity
- bay_area_daily_eq2.rds: results of Eq. 2 (which considers an interaction with mean precipitation intensity) using daily precipitation intensity
- bay_area_daily_eq3.rds: results of Eq. 3 (which considers an interaction with mean slope) using daily precipitation intensity
- bay_area_daily_eq4.rds: results of Eq. 4 (which considers interactions with both mean precipitation and mean slope) using daily precipitation intensity

### california
fit with data for the state of California
- california_daily_eq1.rds: results of Eq. 1 using daily precipitation intensity 
- california_ten_day_eq1.rds: results of Eq. 1 using ten-day antecedent precipitation intensity 
- california_monthly_eq1.rds: results of Eq. 1 using monthly antecedent precipitation intensity
- california_daily_eq2.rds: results of Eq. 2 (which considers an interaction with mean precipitation intensity) using daily precipitation intensity
- california_daily_eq3.rds: results of Eq. 3 (which considers an interaction with mean slope) using daily precipitation intensity
- california_daily_eq4.rds: results of Eq. 4 (which considers interactions with both mean precipitation and mean slope) using daily precipitation intensity

### oregon
fit with data for the state of Oregon
- oregon_daily_eq1.rds: results of Eq. 1 using daily precipitation intensity 
- oregon_ten_day_eq1.rds: results of Eq. 1 using ten-day antecedent precipitation intensity 
- oregon_monthly_eq1.rds: results of Eq. 1 using monthly antecedent precipitation intensity

### washington
fit with data for the state of Washington
- washington_daily_eq1.rds: results of Eq. 1 using daily precipitation intensity 
- washington_ten_day_eq1.rds: results of Eq. 1 using ten-day antecedent precipitation intensity 
- washington_monthly_eq1.rds: results of Eq. 1 using monthly antecedent precipitation intensity

## R Packages Used
- tidyverse, raster, rgdal, zoo, ncdf4, data.table, lfe



