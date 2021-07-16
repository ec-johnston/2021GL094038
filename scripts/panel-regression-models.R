library(lfe)
library(fixest)

## The following strings define panel regression model formulas (i.e., modform) used for bootstrap-models.R  

## MAIN MODEL 

## EQUATION 1: panel regression with grid cell and year fixed effects
eq_1 <- landslides ~ precip:land_use | year + grid_cell

## SUPPLEMENTAL FORMS

## EQUATION 2: includes an interaction with mean precipitation
eq_2 <- landslides ~ precip:land_use + precip:mean_precip:land_use | year + grid_cell

## EQUATION 3: includes an interaction with mean slope
eq_3 <- landslides ~ precip:land_use + precip:slope:land_use | year + grid_cell

## EQUATION 4: includes interactions with mean precipitation and mean slope in the same equation 
eq_4 <- landslides ~ precip:land_use + precip:mean_precip:land_use + precip:slope:land_use | year + grid_cell

## EQUATION 5: tests the log-linear functional form of our main model
eq_5 <- log(landslides) ~ precip:land_use | year + grid_cell
