# _D-statistics_ (ABBA-BABA analysis)

For this analysis, I was working in `/home/jkimball/haasx092/ABBA-BABA`

# Directory
1. [Dsuite](#Dsuite)
2. [AdmixTools](#AdmixTools)

# Dsuite
I am using a program called [Dsuite](https://github.com/millanek/Dsuite).

It was relatively easy to install using instructions from the authors' GitHub page.
```bash
$ git clone https://github.com/millanek/Dsuite.git
$ cd Dsuite
$ make
```
I installed it into a directory called `ABBA-BABA` within my home directory, so the full path to the program is:
```bash
/home/jkimball/haasx092/ABBA-BABA/Dsuite/Buid/Dsuite
```
It can be called within a script with ` ~/ABBA-BABA/Dsuite/Build/Dsuite` for short.

In order to get the sample names out of my `VCF` file so that I could assign them population membership for the D-statistics (ABBA-BABA) analysis, I used the following line of code:
```bash
bcftools query -l biallelic_snps_only.recode.vcf > sample_names_from_vcf.txt
```

I wrote the script [prep_sample_list_for_ABBA-BABA.py](prep_sample_list_for_ABBA-BABA.py) to process the file [sample_names_from_vcf.txt](sample_names_from_vcf.txt) and convert it into the format needed to run Dsuite. For example, the sample names from the `VCF` file look like `Sample_0001/Sample_0001_sorted.bam`, but in the key the sample is just listed as `Sample_0001`. The goal of the script is to connect each sample name to its population assignment from STRUCTURE where _K_=4. As of 4 January 2022, the script does a good job of making the file, except I should update it so that _Zizania aquatica_ samples are labeled as "Outgroup" and samples that don't belong to any population ("None") are labeled as "xxx" so they aren't included in the ABBA-BABA analysis. These correspond to the old/2010 temporal samples so we don't want to include them here. Otherwise, these changes can be made manually but it is better to do it in a robust, reproducible way.

This is a preview of what the file should look like. The complete file can be found [here](sample_list_with_key.txt).
```bash
Sample_0001/Sample_0001_sorted.bam  Natural_stand_2
Sample_0002/Sample_0002_sorted.bam  Natural_stand_2
Sample_0003/Sample_0003_sorted.bam  Natural_stand_2
Sample_0004/Sample_0004_sorted.bam  Natural_stand_2
Sample_0005/Sample_0005_sorted.bam  Natural_stand_2
```

The actual analysis was carried out using the script [run_Dsuite_ABBA-BABA.sh](run_Dsuite_ABBA-BABA.sh).

The results suggest that there have been no introgressions.

# AdmixTools

I followed the instructions to install AdmixTools [here](https://github.com/uqrmaie1/admixtools). Initially, I had issues getting `tidyverse` and `plotly` installed. The final solution that enabled me to install them was to switch from `R/3.6.0` to `R/4.1.0`.

Since I did not already have these R packages installed, I needed to install them so that I could use them in my analysis. The `Rcpp` package was already installed.
```bash
install.packages("tidyverse")
install.packages("igraph")
install.packages("plotly")
```