## Supporting code for manuscript submitted to GRL (2021GL094038R)
## "Quantifying the effect of precipitation on landslide hazard in urbanized and non-urbanized areas"

Elizabeth Johnston (1), Frances Davenport (1), Lijing Wang (2), Jef Caers (2,3), Suresh Muthukrishnan (4,5), Marshall Burke (1,6,7) and Noah Diffenbaugh (1,8)

1. Department of Earth System Science, Stanford University, Stanford, CA 94305
2. Department of Geological Sciences, Stanford University, Stanford, CA 94305
3. Institute for Human-Centered Artificial Intelligence, Stanford University, Stanford, CA 94305
4. Department of Earth, Environmental, and Sustainability Sciences, Furman University, Greenville, SC 29613
5. GIS and Remote Sensing Center, Furman University, Greenville, SC 29613
6. Center on Food Security and the Environment, Stanford University, Stanford, CA 94305
7. Environment and Energy Economics, National Bureau of Economic Research, Cambridge, MA 02138
8. Woods Institute for the Environment, Stanford University, Stanford, CA 94305


Corresponding author: Elizabeth C. Johnston (ecj@stanford.edu)

**Raw datasets are available from the following locations:**

- The Cooperative Open Online Landslide Repository is available from NASA (https://maps.nccs.nasa.gov/arcgis/apps/MapAndAppGallery/index.html?appid=574f26408683485799d02e857e5d9521)
- PRISM daily 4 km precipitation is available from the PRISM Climate Group, Oregon State University (http://www.prism.oregonstate.edu/recent)
- The TIGER/Line shapefile of land use designations is available from the US Census (https://catalog.data.gov/dataset/tiger-line-shapefile-2019-2010-nation-u-s-2010-census-urban-area-national)
- Digital Elevation Model – with SRTM voids filled using accurate topographic mapping – is available at 3 arc second resolution from Jonathan de Ferranti (http://viewfinderpanoramas.org/Coverage%20map%20viewfinderpanoramas_org3.htm). 



## Organization of Repository

- data: post-processed data
- scripts: code for data processing and analysis
- results: regression coefficients

## scripts

- func.R: defines functions used throughout data processing 
- calc-cumulative-precip.R: ten-day and thirty-day precipitation accumulation
- calc-slope.R: calculates slope from a digital elevation model (DEM)
- buffer-rural.R: subdivides rural areas based on proximity to urbanized areas and urban clusters
- panel-regression-models.R: defines panel regression models
- bootstrap-models.R: bootstraps regression models

## data

Reduced data for the US Pacific Coast region at 4 km spatial resolution (regional daily-scale precipitation data not included due to size): 

- pacific_coast_df.rds: dataframe of x/y coordinates within the Pacific Coast region at 4 km resolution 
- pacific_coast.asc: raster layer of the Pacific Coast region at 4 km resolution
- bay_area_df.rds: dataframe of x/y coordinates of coastal San Francisco counties of Marin, San Francisco, San Mateo, and Santa Cruz 
- land_use.rds: land use designation into urbanized (>50,000 people), urban cluster (2,500 – 50,000 people), and rural (<2,500 people)  
- land_use_subdiv.rds: land use classification with rural areas subdivided based on proximity to urban footprint
- slope.rds: slope (in radians)
- landslides.rds: all precipitation-triggered landslides reported by COOLR
- landslides_precip.rds: one-day, ten-day, and thirty-day precipitation accumulation preceding observed landslides

## results

Bootstrapped coefficients from panel regression models

## R Packages Used
- tidyverse, raster, rgdal, zoo, ncdf4, data.table, lfe



