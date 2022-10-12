# RnASeQ: RNA-Seq Analysis Workflow with Snakemake
![License: MIT](https://img.shields.io/badge/ubuntu-20.04.3-green.svg)
[![Conda:hisats](https://img.shields.io/badge/snakemake-v7.14.0-green.svg)](https://snakemake.github.io/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

RnASeQ performs measuring and comparing the levels of gene expression in a wide variety of species and conditions. It supports mapping of fastq rna-seq raw reads  to both genome and transcriptome. The RnASeQ is planned to include various types of RNA-seq analysis

- Functional profiling with RNA-seq
- Identify short variants (SNPs and Indels) in RNAseq data
- Alternative splicing analysis
- Small RNAs
- Gene fusion discovery

# Workflow:
<p align="center">
  <img  src="https://user-images.githubusercontent.com/66043140/194846073-8548eff8-3e5b-4a00-9481-4be4811d92c3.png" >
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


``` python3 collapse_annotation.py genome.gtf genome_rnaseqc.gtf ``` 

4- Adjust **config.yaml** to be suitable for your case

```
# index
IndexAssembly: "hisat2"    # "hisat2" with genome or "kallisto" with transcriptome or  " " if you have index already
indexname: "genomehuman38" # Name the index or Type the name of index in "Assembly"

# Direct the analysis
map: "Ganome"       # "Genome" or  "Transcriptome" 
end: "paired"       # "single" or "paired"
ext:                # extension of fastq file
  f: ".fastq.gz"    # any extanstion of fastq file (paired & single)
  f1: "_R1_001.fastq.gz"     # any extanstion of fastq file (paired)
  f2: "_R2_001.fastq.gz"     # any extanstion of fastq file (paired)
  strandness: "RF"  # paired "FR" or "RF"  / single "F" or "R"

# Threads
th:
  max: 48
  normal: 16

# Assembly and Annotation files
Assembly: "Assembly/genome.fa" #genome/transcriptome fasta file
gtf: "Assembly/genome.gtf"     #genome/transcriptome gtf file
gtfqc: "Assembly/genome.gtf"  #genome gtf file for rnaseqc
```
5- Perpare file.csv for each compared groups (case vs control) (use Excel to make the file as shown below)

```
,condition
SRR1039513,case
SRR1039512,case
SRR1039508,control
SRR1039509,control
```
You can design many file.csv but you have to ensure that
- They have different file name
- Sample name is mateched with fastq file name for example:
sample name: SRR1039513 
fastq file: SRR1039513_R1_001.fastq.gz SRR1039513_R2_001.fastq.gz (paired-end) or SRR1039513.fastq.gz (single-end)

6-  RUN ``` snakemake --cores all  --use-singularity  --use-conda ``` in the RnASeq directory 

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
