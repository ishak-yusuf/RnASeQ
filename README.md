# RnASeQ: RNA-Seq Analysis Snakemake Workflow
[![Conda:hisats](https://img.shields.io/badge/snakemake-v7.14.0-green.svg)](https://snakemake.github.io/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)





RnASeQ performs a differential gene expression analysis with Hisat2 and Deseq2. It supports mapping fastq rna-seq raw reads to genome and it can do gene-level Differential Expression Analysis (DEA) when genome is used as mapping reference.


# Workflow:
<p align="center">
  <img  src="https://user-images.githubusercontent.com/66043140/191437707-f589fb0f-bcd3-4844-90a0-94c48b3711a1.png">
  </p>
  
# Tools: 
| steps | tools|
| :---:   | :---:  |
| quality control |[![Conda:hisats](https://img.shields.io/badge/bioconda-multiqc-blue.svg)](https://anaconda.org/bioconda/multiqc) [![License: MIT](https://img.shields.io/badge/bioconda-fastqc-blue.svg)](https://anaconda.org/bioconda/fastqc) |
| step1: map to genome |[![Conda:hisats](https://img.shields.io/badge/bioconda-Hisat2-important.svg)](https://anaconda.org/bioconda/hisat2) |
| step2: assess the alignment |[![License: MIT](https://img.shields.io/badge/bioconda-rna--seqc-blue.svg)](https://anaconda.org/bioconda/rna-seqc) |
| step3: quantification |[![Conda:subread](https://img.shields.io/badge/bioconda-subread-critical.svg)](https://anaconda.org/bioconda/subread) |
| step4: different gene expression |[![Conda:deseq2](https://img.shields.io/badge/bioconductor-deseq2-important.svg)](https://anaconda.org/bioconda/bioconductor-deseq2)|
| step5: visualisation | [![Conda:subread](https://img.shields.io/badge/conda--forge-r--ggplot2-important.svg)](https://anaconda.org/conda-forge/r-ggplot2)|

