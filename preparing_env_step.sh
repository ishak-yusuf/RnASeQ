# The script is designed corresponding with ubuntu 22.04 and server already have conda environment.
conda create -n rnaseq_env
conda install -c bioconda hisat2
conda install -c bioconda samtools
conda install -c bioconda subread
