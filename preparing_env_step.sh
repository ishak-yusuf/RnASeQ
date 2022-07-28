# The script is designed corresponding with ubuntu 22.04 and server already have conda environment.
conda create -n rnaseq_env
conda install -c bioconda hisat2
conda install -c bioconda samtools
conda install -c bioconda subread
mkdir refhg38
cd refhg38
wget https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_40/GRCh38.p13.genome.fa.gz
gunzip GRCh38.p13.genome.fa.gz
hisat2-build GRCh37.p13.genome.fa GRCh37.p13.genome.fa -p $1
