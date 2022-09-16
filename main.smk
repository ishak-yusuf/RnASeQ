import os


def getidlist():
    id_list = []
    for i in os.listdir():
        # gets list of fastqs:
        if i.endswith("_R1_001.fastq.gz"):
            id = os.path.basename(i)[:-16]
            id_list.append(id)
    return id_list


# Bulid output folder
os.system("mkdir output")


rule all:
    input:
        expand("{dir}/{sample}.sorted.bam", sample=getidlist(), dir="output"),
        expand("{dir}/counts_all.txt", dir="output"),


rule hisat2_alignment:
    input:
        f1="{sample}_R1_001.fastq.gz",
        f2="{sample}_R2_001.fastq.gz",
    output:
        "{sample}.sorted.bam",
    params:
        ref="/home/genwork2/Desktop/05.ref_area/ref_hisat2_annhg38p13/GRCh38.p13.genome.fa",
        strandness="FR",
    threads: 10
    message:
        """--- Alignment with Hisat"""
    log:
        "output/{sample}.log",
    resources:
        mem_gb=15,
        rate_limit=1,
    # conda: ""
    shell:
        """
        hisat2 -q --rna-strandness {params.strandness} -x {params.ref} -1 {input.f1} -2 {input.f2} -p {threads} |\
        samtools sort -o {output} -@ {threads} 2> {log}
        """


rule featureCounts:
    input:
        expand("{dir}/{sample}.sorted.bam", sample=getidlist(), dir="output"),
    output:
        "output/counts_all.txt",
    params:
        gff="/home/genwork2/Desktop/05.ref_area/ref_hisat2_annhg38p13/gencode_annotation.gff3",
        g="gene_name",
        t="exon",
    threads: 40
    log:
        "output/counts_all.txt.log",
    resources:
        mem_gb=126,
    # conda: ""
    shell:
        "featureCounts  -t {params.t}  -g  {params.g}  -a {params.gff} -o {output} -T {threads} {input} 2> {log}"
