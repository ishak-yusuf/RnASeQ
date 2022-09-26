# RnASeQ: RNA-Seq Analysis Snakemake Workflow
![License: MIT](https://img.shields.io/badge/ubuntu-20.04.3-green.svg)
[![Conda:hisats](https://img.shields.io/badge/snakemake-v7.14.0-green.svg)](https://snakemake.github.io/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

RnASeQ performs a differential gene expression analysis with Hisat2 and Deseq2. It supports mapping fastq rna-seq raw reads to genome and obtains gene-level Differential Expression Analysis (DEA) when genome is used as mapping reference.



# Workflow:
<p align="center">
  <img  src="https://user-images.githubusercontent.com/66043140/191448492-4ae0c646-d86e-4512-a414-e91623a48985.png">
  </p>
  
# Tools: 
| steps | tools|
| :---:   | :---:  |
| quality control |[![Conda:hisats](https://img.shields.io/badge/docker--staphb-multiqc-blue.svg)](https://hub.docker.com/r/staphb/multiqc) [![License: MIT](https://img.shields.io/badge/docker--staphb-fastqc-blue.svg)](https://hub.docker.com/r/staphb/fastqc) |
| step1: map to genome |[![Conda:hisats](https://img.shields.io/badge/bioconda-Hisat2-important.svg)](https://anaconda.org/bioconda/hisat2) |
| step2: assess the alignment |[![License: MIT](https://img.shields.io/badge/bioconda-rna--seqc-blue.svg)](https://anaconda.org/bioconda/rna-seqc) |
| step3: quantification |[![Conda:subread](https://img.shields.io/badge/bioconda-subread-critical.svg)](https://anaconda.org/bioconda/subread) |
| step4: different gene expression |[![Conda:deseq2](https://img.shields.io/badge/bioconductor-deseq2-important.svg)](https://anaconda.org/bioconda/bioconductor-deseq2)|
| step5: visualisation | [![Conda:subread](https://img.shields.io/badge/conda--forge-r--ggplot2-important.svg)](https://anaconda.org/conda-forge/r-ggplot2)|

