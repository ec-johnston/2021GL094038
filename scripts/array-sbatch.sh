#!/bin/bash

#SBATCH --job-name=boot_all
#SBATCH --error=/oak/stanford/groups/xxxxxxx/group_members/xxx/landslide_felm_PRISM/felm_01d/pacificCoast_states/main/felm_boot_%a.err
#SBATCH --output=/oak/stanford/groups/xxxxxxx/group_members/xxx/landslide_felm_PRISM/felm_01d/pacificCoast_states/main/felm_boot_%a.out
#SBATCH --array=1-200%5
#SBATCH --time=2:00:00
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=150GB
#SBATCH --mail-type=END,FAIL 
#SBATCH --mail-user=
#SBATCH -p xxxxxxxxx

module load R
ml load physics geos
ml load physics gdal
ml load physics proj 
ml load udunits

cd /oak/stanford/groups/xxxxxxx/group_members/xxx/landslide_felm_PRISM/felm_01d/pacificCoast_states/main/
## arguements for bootstrapping are: ARRAY_ID NBOOT modname modform datafile cluster_varname
Rscript ./bootstrap-models.R $SLURM_ARRAY_TASK_ID 5 felm "landslides ~ precip:land_use | year + grid_cell" "./dataframe_01d.rds" ID 
