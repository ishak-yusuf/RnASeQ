# RnASeQ: RNA-Seq Analysis Workflow with Snakemake
![License: MIT](https://img.shields.io/badge/ubuntu-20.04.3-green.svg)
[![Conda:hisats](https://img.shields.io/badge/snakemake-v7.14.0-green.svg)](https://snakemake.github.io/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

RnASeQ is to perform measuring and comparing the levels of gene expression in a wide variety of species and conditions. It supports mapping of fastq rna-seq raw reads to genome and transcriptome assemblies and visualise differential gene expression analysis.


# Workflow:
<p align="center">
  <img  src="https://user-images.githubusercontent.com/66043140/194316017-7c48648b-0187-4462-836f-876b93fc9ae2.png">
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
| Visualisation | [![Conda:subread](https://img.shields.io/badge/conda--forge-r--ggplot2-important.svg)](https://anaconda.org/conda-forge/r-ggplot2)|


 
# How to run RnASeQ on your machine:
1- Install  <a href="https://snakemake.readthedocs.io/en/stable/getting_started/installation.html" target="_blank">snakemake </a>

2- Download the *RnASeq* directory and add **paired FASTQ files** to *input* folder

3- (genome only) Prepare gtf for rnaseqc by **collapse_annotation.py** <a href="https://raw.githubusercontent.com/broadinstitute/gtex-pipeline/master/gene_model/collapse_annotation.py" target="_blank">here </a>


``` python3 collapse_annotation.py genome.gtf genome_rnaseqc.gtf ``` 

4- Adjust **config.yaml** to be suitable for your case

```
#QC
trim: yes                  # yes or no
adapter: "nextera"         # "illumina" or "nextera"

#index
index: yes                 # yes or no

#Direct the analysis
map: "map_to_ganome"       # "map_to_ganome" or  "map_to_transcriptome"
end: "paired"              # "single" or "paired"
ext:                       #extension of fastq file
  f: ".fastq.gz"           # any extanstion of fastq file
  f1: "_R1_001.fastq.gz"   # any extanstion of fastq file (forward)
  f2: "_R2_001.fastq.gz"   # any extanstion of fastq file (reverse)
  strandness: "RF"         # paired "FR" or "RF"  / single "F" or "R"

#Threads
th:
  max: 48
  normal: 16

# Assembly and Annotation files
gen: "genome/genome"        #gene/transcriptome index
gene_fa: "genome/genome.fa" #gene/transcriptome fasta file
gtf: "genome/genome.gtf"    #gene/transcriptome gtf file
```
5-  RUN ``` snakemake --cores all  --use-singularity  --use-conda ``` in the RnASeq directory 

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

4- **Visualisation** : folder has volcanoplot, MA plot and Heatmap

# Main Reference:

Zhang, X., Jonassen, I. RASflow: an RNA-Seq analysis workflow with Snakemake. BMC Bioinformatics 21, 110 (2020). https://doi.org/10.1186/s12859-020-3433-x
