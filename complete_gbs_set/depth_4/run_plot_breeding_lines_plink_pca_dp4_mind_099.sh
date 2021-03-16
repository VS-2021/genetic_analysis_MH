#!/bin/bash -l
#SBATCH --nodes=1
#SBATCH --ntasks=32
#SBATCH --time=24:00:00
#SBATCH --mem=30g
#SBATCH --mail-type=ALL
#SBATCH --mail-user=haasx092@umn.edu
#SBATCH -p amdsmall
#SBATCH --account=jkimball
#SBATCH -o plot_plink_pca_20NA_breeding_lines_dp4_mind_099.out
#SBATCH -e plot_plink_pca_20NA_breeding_lines_dp4_mind_099.err

cd /home/jkimball/haasx092/main_GBS/210306_samtools

module load R/3.6.0

Rscript plot_breeding_lines_plink_pca.R  plink_20percent_NA_pca_breeding_lines_dp4_mind_099.eigenvec plink_20percent_NA_pca_breeding_lines_dp4_mind_099.eigenval 210306_main_gbs_20percent_NA_breeding_lines_dp4_mind_099.pdf 210306_main_gbs_20percent_NA_breeding_lines_dp4_mind_099.Rdata
