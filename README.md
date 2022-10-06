# RnASeQ: RNA-Seq Analysis Snakemake Workflow
![License: MIT](https://img.shields.io/badge/ubuntu-20.04.3-green.svg)
[![Conda:hisats](https://img.shields.io/badge/snakemake-v7.14.0-green.svg)](https://snakemake.github.io/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

RnASeQ performs the RNA seq analysis in any organism. It supports mapping of fastq rna-seq raw reads to genome / transcriptome assemblie and obtains Differential gene expression analysis (Diffexp) among couple of conditions, cases and controls.  


# Workflow:
<p align="center">
  <img  src="https://user-images.githubusercontent.com/66043140/194316017-7c48648b-0187-4462-836f-876b93fc9ae2.png">
  </p>


# Tools: 
| steps | tools|
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

3- Add **geneome.fa** , **genome Hisat2 index** and **genome.gtf** to *genome* folder

4- Prepare gtf for rnaseqc by **collapse_annotation.py** <a href="https://raw.githubusercontent.com/broadinstitute/gtex-pipeline/master/gene_model/collapse_annotation.py" target="_blank">here </a>


``` python3 collapse_annotation.py genome.gtf genome_rnaseqc.gtf ``` 

5- Adjust **config.yaml** to be suitable for your case

```
ext :                       #extension of fastq file
  f: ".fastq.gz"
  f1: "_R1.fastq.gz"
  f2: "_R2.fastq.gz"
th:    #threads
  max: 48
  normal: 16
gen: "genome/genome"        #gene index for hisat2
gene_fa: "genome/genome.fa" # genome fasta file
gtf: "genome/genome_rnaseqc.gtf" #annotation gtf file
```
6-  RUN ``` snakemake --cores all  --use-singularity  --use-conda ``` in the RnASeq directory 

# Expected outcome:

The five folders re going to be extracted.

1- **QC** : has all fastqc, multiqc and seqkit files 

2- **step1** : has all sorted bam files

3- **step2** : has alignment_rate.csv and rnaseqc_sheet.csv

4- **step3** : includes counts_all.txt 
