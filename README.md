# README for genetic_diversity
This repository contains all of the scripts that were used to develop the genotyping-by-sequencing (GBS) pipeline for the wild rice (_Zizania palustris_ L.) breeding and conservation program at the University of Minnesota.

We used multiple SNP-calling pipelines in the development of this project.
1. [SAMtools/BCFtools](SAMtools-BCFtools)
2. [FreeBayes](FreeBayes)
3. [TASSEL](TASSEL)
4. [stacks](stacks)

The goal of each of these pipelines was to generate a Variant Call Format (VCF) file containing SNP data for our population to be used in further analysis.

Principal Component Analysis (PCA) plots were generated using [PLINK](http://zzz.bwh.harvard.edu/plink/) version 1.90b6.10. Those files can be found [here](plink_files).

The directory [imputation](imputation) contains scripts to impute missing genotype calls, although these were not used in the final analysis.

The directory [pop_gen_analyses](pop_gen_analyses) contains scripts used to conduct many of the population genetic analyses for this project.

The directory [umgc_pilot_study](umgc_pilot_study) contains some scripts that were used in the pilot GBS study by [Shao _et al._ (2020)](https://link.springer.com/content/pdf/10.1007/s12686-019-01116-9.pdf).

This figure shows the location of collection sites on public, non-tribal land in Minnesota and Wisconsin.<br>
<img src="images/200402_collection_map.png" width="500">


Principal component analysis plot for the temporal samples:<br>
<img src="images/210311_main_gbs_20percent_NA_temporal_Page_1.png" width="500">

## awk_filtering_scripts (directory)
These scripts are short and simple awk commands to pre-filter the tab-separated (TSV) files that contain the output of the normalize.awk script. The normalize.awk script can be found in this repository and is used to extract SNP information from the VCF files.

## complete_gbs_set (directory)
These scripts were used to process the gbs data from the natural stands + breeding lines material (no Johnson/Dora population or Dovetail lines). Currently, the scripts pick up from VCF files (samtools mpileup & bcftools call script has already been run). The tsv file created with normalize.awk was 129G in size and one of the scripts here filters based on read depth (minimum of 5 reads).

## depth_reanalysis_pilot_data (directory)
Scripts for re-analyzing depth of pilot GBS data using the reference genome. Aim is to to calculate density of SNPs for use in genome paper.

## pairwise_distance (directory)
These scripts are for creating pairwise distance tables in R

## pca_from_poppr (directory)
These scripts are for creating a PCA plot with the R package poppr. It was created when I began investigations into low Fst values (0.03-0.05) which were calculated using VCFtools. The plots look similar to the one created using PLINK, but explain less of the variation. That matches the low Fst values, but based on previous research we expect an Fst value closer to 0.3, so these files should ultimately be able to validate the PLINK results.

## plink_files (directory)
These scripts are for using plink to process/analyze large-scale GBS SNP data

## umgc_pilot_study (directory)
These scripts are for the (partial) re-analysis of the pilot GBS study conducted by the University of Minnesota Genomics Center (UMGC). I say partial because I start the re-analysis from the VCF files produced by their pipeline. For their pipeline, they used a program called stacks (http://catchenlab.life.illinois.edu/stacks/). The reference genome of _Zizania palustris_ was not used in this pipeline. I was mostly interested in pulling some stats out of the files and re-creating the PCA plot to meet my style preferences. The paper was accepted for publication in Conservation Genetics Resources.

## 190515_cutadapt_pilot_GBS
This file is the "complete" GBS pipeline that was initiated on 15 May 2019. It can be broken down into a few major steps:
1. Removing adapter content with cutadapt
2. Running fastQC on trimmed reads
3. Aligning trimmed fastq reads to the genome with bwa-mem
  - Indexing genome
  - Performing alignment
  - Sorting BAM files
4. SNP calling with samtools mpileup/bcftools call
  - There are two parameters to pay especially close attention to.
    - The -q option for samtools mpileup allows us to specify a _minimum_ mapping quality. A minimum mapping quality value of 20 might be "standard", but I used a value of 60 for some interations of the experiment which might be a little too stringent and results in otherwise useful SNPs being filtered out of the dataset. (Reference: http://www.htslib.org/doc/samtools-1.2.html)
    - The -m option for bcftools call stands for the _multiallelic caller_. It is an alternative method for multi-allelic and rare-varient calling that overcomes known limitations to the -c option which stands for _consensus_ caller. The consensus caller is the original option. Because these options conflict with each other, only one can be used at a time.(Reference: https://samtools.github.io/bcftools/bcftools.html)
5. Pulling the SNP information out of the VCF files and into usable format
  - The script "normalize.awk" extracts the following information from the VCF files: 1) scaffold, 2) position, 3) reference allele, 4) alternate allele, 5) base quality score, 6) sample identifier (path to BAM file), 7) genotype call (0, 1, or 2), 8) read depth (DP) at site, and 9) depth of the varient (DV) allele at the site.

## 190913_pilot_GBS_snp_filtering_wide_format_q60.R
This file contains R code that reformats SNP data from the pilot study. It loads a pre-existing Rdata file and outputs a comma-separated (CSV) file. Otherwise, this code is pretty simple. It takes data in long format and converts it to wide format before writing the CSV file.
  - The input Rdata file is: 190627_snp_filtering_q60.Rdata
  - The output Rdata file is: 190913_pilot_GBS_snip_filtering_wide_format_q60.Rdata
  - The CSV file is: 190913_pilot_GBS_snp_filtering_wide_format_q60.csv
  
## 190913_snp_calling_from_190607_samtools_pilot_GBS.R
This file contains R code for generating a SNP table for the pilot study (excluding _Z. latifolia_).
  - Input Rdata file: 190607_snp_filtering.Rdata
  - Output Rdata file: 190913_snp_calling_from_190607_samtools_pilot_GBS.Rdata
  - Output CSV file: 190913_snp_calling_from_190607_samtools_pilot_GBS.csv
  
## 191002_pca_from_vcf_subset_of_main_GBS_data.R
The purpose of this code is to create a PCA plot directly from the VCF files for the first 50 samples of the main_GBS project. It only considered Scaffold_48. I used this approach because I was having a hard time getting all of the data to load and run at once without the system crashing.
  - Input files: 1) '191001_samtools_Scaffold_48;HRSCAF=1451.vcf.gz', 2) 191002_first_fifty_lines.csv
  - Output files: 1) 191002_pca_from_vcf_subset_of_main_GBS_data.pdf, 2) 191002_pca_from_vcf_subset_of_main_GBS_data.Rdata

## filter_vcf_by_maf.sh
This is a PBS batch script to filter (& recode) VCF files so that they are filtered for a minor allele frequency of at least 0.05. There is also a flag (--remove) along with a text file that contains the sample numbers (one per line) that belong to the Old Lake samples to remove them from consideration. The script does this individually for specific VCF files and then concatenates them into a larger VCF file to feed into either PLINK or the R package _poppr_.

## create_snp_list_from_plink
The purpose of this code is to use plink (http://zzz.bwh.harvard.edu/plink/) to create a SNP list (table).

## main_GBS_directory_setup.txt
The purpose of this code was to set up the directory structure for **main_GBS**. First, it creates a text file with the paths to the fastq files in the UMGC directory (_/home/jkimball/data_release/umgc/novaseq_). Please note that the UMGC released the GBS data in two waves. One set is in the directory **190730_A00223_0174_BHCN5GDRXX/Kimall_Project_002** while the other is in the directory **190819_A00223_0191_AHF3V3DRXX/Kimball_Project_002**.
  - The pilot data (**Kimball_Project_001**) are in a different directory because they were sequenced using the **NextSeq** platform. That path is: **181030_NB551164_0099_AHVM22BGX7/Kimball_Project_001**
  - The RNA-seq data are part of **Kimball_Project_003** and can be found in **190828_A00223_0198_BHCMFVDRXX/Kimball_Project_003**
  - _Please note that these are **relative** paths and assume you are already in the directory /home/jkimball/data_release/umgc/novaseq or /home/jkimball/data_release/umgc/nextseq (in the case of the pilot study)_.

The code then makes symbolic links (symlinks) to the fastq files in the directory _/home/jkimball/haasx092/**main_GBS**_. The fastq file names generally begin with a pattern like "18NS###" or "18BL##" with NS standing for "natural stand" and BL standing for "breeding line". We have information on where these come from, but to make computations easier (especially pattern matching), I wanted to use a number that was in the middle of the filename (S##). Leading zeros were added to the sample numbers so that all sample numbers would have 4 digits. This was done to make sorting of samples easier (so that the order would be: 1, 2, 3, etc and not 1, 10, 100).

A file (paths_to_gbs_data_check.txt) was also created to verify that the code worked. The result is that it worked as expected.

## main_GBS_pipeline
This code is very similar to the file **190515_cutadapt_pilot_GBS** but is a better reflection of what was done for the **main_GBS** analysis.

## pca_from_vcf.R
This is R code that generates a PCA plot directly from VCF files. It was first used for the pilot GBS project and it worked very well for those samples. The seventeen largest VCF files were concatenated into a single VCF file called **seventeen_largest_vcfs_merged.vcf.gz** using bcftools concat. That file was used as input to generate:
  - The PCA plot (190705_pilot_GBS_PCA.pdf); and
  - The Rdata file (190705_pca_from_vcfs.Rdata)
  
Please note that multiple different modules are required to be loaded on the command line before beginning the R session.

## plink_for_main_GBS
This file contains command line code that used plink to generate a PCA plot for the main GBS project.

It uses the seventeen largest VCFs (as was done with the pilot study) but these data came from the directory _190910_samtools_ which was the first attempt at the using the GBS pipeline for the main GBS dataset. The code was run in that directory.

Input files include:
  - Eigenvalue and eigenvector files made by plink (myplink_pca.eigenval & myplink_pca.eigenvec);
  - The sample key (191008_main_GBS_sample_key.csv)
  
Output files include:
  - One PCA plot (191008_main_GBS_pca_from_plink.pdf);
  - Another PCA plot, colored according to file name (191009_main_GBS_PCA_Itasca_and_JohnsonDoraF4.pdf);
  - The Rdata files (191008_main_GBS_pca_from_plink.Rdata & 191009_main_GBS_pca_from_plink.Rdata)
  
## plotting_dv-dp_ratios.r
This is R code that plots the DV/DP ratio for each sample in the pilot study. DV/DP stands for "depth of the variant/total depth". The purpose of the code was to verify the diploid nature of _Zizania palustris_ given that the genome size came back much larger than expected.

Input file:
  - An R data file containing filtered SNP data (190607_snp_filtering.Rdata)

Output file:
  - The plots (190609_pilot_GBS_samples_dv-dp_ratio.pdf)
  
## poppr_installation.R
This shows the steps that I took to install the R package "poppr" (https://cran.r-project.org/web/packages/poppr/index.html). It was more complicate than a standard R package. For the same reason, every time the package is used in R, the same software packages need to be re-loaded. I haven't needed to run this specific code again since I installed it the first time.

## run_bwa.sh
This is simply partial generic command-line code that runs the burrows-wheeler aligner (bwa; http://bio-bwa.sourceforge.net/). It is in a format that can be submitted to the Minnesota Supercomputing Institute (MSI) batch submission system. The basic code can also be found in the pilot GBS (**190515_cutadapt_pilot_GBS**) or main GBS (**main_GBS_pipeline**) files.

## snp_characteristics_from_pilot_study.R
This is R code that I used to find basic SNP characteristics from the pilot study to be presented at the Cultivated Wild Rice Field Day in Grand Rapids, MN on 1 August 2019.

Input file:
  - 190627_snp_filtering_q60.Rdata
  
Output file:
  - 190729_getting_SNP_stats_for_field_day.Rdata

## scythe_mpileup.sh
This is a script written with the help of Tom Kono to run the samtools mpileup part of the GBS pipeline in a a better, more efficient way. When the samtools mpileup part of the pipeline is entered directly on the command line and subsequently put into the background, each samtools process runs for ~15 minutes before being killed by the server. **I think this is the ultimate cause of the low number of SNPs identified** When I tried to turn the script (as it was) into a batch submission script for MSI, I received an error (argument too long) which was caused by parallel, but when I took parallel out, the region option (-r '{}') was not recognized. This script has the same basic skeleton as before, but was reworked so that parallel could work with it. Otherwise (with the old script--parallel and the -r '{}' option removed), all of the variants are written to a single VCF file and takes longer than 24 hours to finish.. So scythe_mpileup.sh represents a major improvement.

## snp_density_from_pilot_for_circos
This file contains R code that finds SNP density for each scaffold to add to the circos plot that I generated to visualize links between the _Zizania palustris_ and _Oryza sativa_ genomes. It works, but could still use improvement. The biggest area for improvement would be to ensure that chromosome/scaffold lengths match up between circos input text files.

Input file:
  - 190627_snp_filtering_q60.Rdata
  
Output files:
  - 190725_snp_density_for_circos.Rdata
  - Many other small text files (e.g., scf1_snp_density, scf3_snp_density, etc ) that are used as input for circos. More details can be found in the circos repository (https://github.com/MatthewHaas/circos).


## snp_filtering.R
This is R code that can be used for filtering SNPs. As input, it takes the tab-separated file (TSV) that is created at the end of the GBS pipeline (after using normalize.awk). In this case, it is used to filter SNPs with a minimum quality score of 40 and a minimum read depth of 50. It should be noted that the depth of 50 is far too strict for our GBS pipeline (as a depth of 10 was also too strict..a depth of 5 is sufficient). This is not surprising given that each sample was only sequenced to a depth of 2 million.

Basic elements of this code (reading in data, giving columns meaningful names, and simplifying the sample names can be re-used for the pipeline).

Input file:
  - 190607_normalize.tsv
  
Output file:
  - 190607_snp_filtering.Rdata
