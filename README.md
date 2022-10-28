# RnASeQ: RNA-Seq Analysis Workflow with Snakemake
![License: MIT](https://img.shields.io/badge/ubuntu-20.04.3-green.svg)
[![Conda:hisats](https://img.shields.io/badge/snakemake-v7.14.0-green.svg)](https://snakemake.github.io/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

RnASeQ performs measuring and comparing the levels of gene expression in a wide variety of species and conditions. It supports mapping of fastq rna-seq raw reads  to both genome and transcriptome. The RnASeQ is planned to include various types of RNA-seq analysis

- Functional profiling with RNA-seq
- Identify short variants (SNPs and Indels) in RNAseq data
- Small RNAs

# Workflow:
<p align="center">
  <img  src="https://user-images.githubusercontent.com/66043140/198525715-6033474d-b808-4d24-8721-bb14a53df60b.jpg" >
  </p>


# Tools: 
| Steps | Tools|
| :---:   | :---:  |
| QC |[![Conda:hisats](https://img.shields.io/badge/docker--staphb-multiqc-blue.svg)](https://hub.docker.com/r/staphb/multiqc) [![License: MIT](https://img.shields.io/badge/docker--staphb-fastqc-blue.svg)](https://hub.docker.com/r/staphb/fastqc) |
| genomeG + step1G |[![Conda:hisats](https://img.shields.io/badge/docker--condaforge-mambaforge-blue.svg)](docker://condaforge/mambaforge) [![Conda:hisats](https://img.shields.io/badge/bioconda-Hisat2-important.svg)](https://anaconda.org/bioconda/hisat2)  |
| step2G |[![License: MIT](https://img.shields.io/badge/bioconda-rna--seqc-blue.svg)](https://anaconda.org/bioconda/rna-seqc) |
| step3G |[![Conda:subread](https://img.shields.io/badge/bioconda-subread-critical.svg)](https://anaconda.org/bioconda/subread) |
| step4G | [![Conda:deseq2](https://img.shields.io/badge/bioconductor-deseq2-important.svg)](https://anaconda.org/bioconda/bioconductor-deseq2) |
| transT + Step1T | [![docker:kallisto](https://img.shields.io/badge/docker-kallisto-important.svg)](https://hub.docker.com/r/zlskidmore/kallisto) |
| Step2T  | [![bioconductor:edger](https://img.shields.io/badge/bioconductor-edger-important.svg)](https://anaconda.org/bioconda/bioconductor-edger) |


 
# How to run RnASeQ on your machine:
1- Install  <a href="https://snakemake.readthedocs.io/en/stable/getting_started/installation.html" target="_blank">snakemake </a> and 
<a href="https://docs.docker.com/engine/install/ubuntu/" target="_blank"> docker </a> 

2- Download the *RnASeq* directory and add **paired-end** / **single-end** FASTQ files to *input* folder

3- Prepare gtf for rnaseqc by **collapse_annotation.py** <a href="https://raw.githubusercontent.com/broadinstitute/gtex-pipeline/master/gene_model/collapse_annotation.py" target="_blank">here </a> (genome only) 

``` python3 collapse_annotation.py file.gtf file_adjusted.gtf ``` 

4- INdex the reference genome according to
hisat2
``` hisat2-build -p th input.genome index.name ```

kallisto
``` ```



5- Metadata table: 

Add sampleA_sampleB.csv to the **input** folder with fastq files. 

```
value,condition
sampleA-1,case
sampleA-2,case
sampleA-3,case
sampleB-1,control
sampleB-2,control
sampleB-3,control
```


6- Adjust **config.yaml** to be suitable for your case. 
The example/example config folder include all different scenarios of config.yaml.

```
# index
indexname: "genomehuman38" # Name the index or Type the name of index in "Assembly"

# Direct the analysis
map: ""       # "Genome" or  "Transcriptome" 
end: ""       # "single" or "paired"
ext:                # extension of fastq file
  f: ""    # any extanstion of fastq file (paired & single)
  f1: ""     # any extanstion of fastq file (paired)
  f2: ""     # any extanstion of fastq file (paired)
  strandness: ""  # paired "FR" or "RF"  / single "F" or "R"

# Threads
th: (based on the used machine)
  max: 48 
  normal: 16

# Assembly and Annotation files
Assembly: "" #genome/transcriptome fasta file
gtf: ""     #genome/transcriptome gtf file
gtfqc: ""  #genome gtf file for rnaseqc

```
7-  RUN ``` snakemake --cores all  --use-singularity  --use-conda ``` in the RnASeq directory 

# Expected outcome:

The five folders re going to be extracted.

1- **QC** : has all fastqc, multiqc and seqkit files 

**GENOME**

2- **step1G** : has all sorted bam files

3- **step2G** : has alignment_rate.csv and rnaseqc_sheet.csv

4- **step3G** : includes counts_all.txt 

5- **step4G** : folder has normalized data with Deseq2

**TRANSCRITOME**

2- **Step1T**: folder has all TPM reads for each sample

3- **Step2T**: folder has normalized data with edger



# Main References:

- Zhang, X., Jonassen, I. RASflow: an RNA-Seq analysis workflow with Snakemake. BMC Bioinformatics 21, 110 (2020). https://doi.org/10.1186/s12859-020-3433-x

- Conesa, A., Madrigal, P., Tarazona, S. et al. A survey of best practices for RNA-seq data analysis. Genome Biol 17, 13 (2016). https://doi.org/10.1186/s13059-016-0881-8
