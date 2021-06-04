## THIS SCRIPT IS MODIFIED FROM FRANCES DAVENPORT (see Davenport et al., 2019; 2021)

## THIS SCRIPT IS WRITTEN FOR GENERAL BOOTSTRAPPING OF A FIXED EFFECTS LINEAR MODEL
## USING FELM
## ALL DATA-WRANGLING MUST TAKE PLACE BEFOREHAND

library(dplyr)
library(lfe)

## -----------------------------------------------------------------------------
## read in arguments from sbatch script
args <- commandArgs(trailingOnly = TRUE)
ARRAY_ID <- as.numeric(args[1]) ## job number within array - used to set seed and in outfile name
NBOOT <- as.numeric(args[2]) ## number of bootstraps for each job
modname <- args[3] ## shorthand name to save output
modform <- args[4] ## string specifying model formula
datafile <- args[5] ## location of dataframe to use
cluster_varname <- args[6] ## which variable to sample by (in our case, grid cells)

## OUTPUT FILE -----------------------------------------------------------------
outfile <- paste0("./output/", modname, "_bootstrap_", ARRAY_ID, ".Rds")

## ECHO INPUT VARIABLES --------------------------------------------------------
print("Model Name:")
print(modname)
print("Model Formula:")
print(modform)
print("Bootstrapping by...")
print(cluster_varname)
print("Output File:")
print(outfile)
## -----------------------------------------------------------------------------

data <- readRDS(datafile)

## split into list of dataframes (one for each grid cell)
data_split <- split(data, f = data[,cluster_varname])

## number of clusters to sample (i.e., original number of grid cells in dataset)
N <- length(unique(data[,cluster_varname]))

## generate matrix of random numbers to resample with replacement
set.seed(100*ARRAY_ID)
sample_list <- lapply(1:NBOOT, function(x) sample(1:N, N, replace = TRUE))

## create matrix to store results
bootresults <- vector('list', length = NBOOT)

## bootstrap model
for(i in 1:NBOOT){
    if(i%%10 == 0) print(i)
    current_data <- do.call(bind_rows, data_split[sample_list[[i]]])
    current_model <- felm(formula(modform), data = current_data, nostats = TRUE)
    bootresults[[i]] <- coef(current_model)
}

saveRDS(bootresults, outfile)
