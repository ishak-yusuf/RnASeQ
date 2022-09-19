configfile: "config.yaml"


import os


def getidlist():
    extantion_fq = "_R1_001.fastq.gz"
    id_list = [
        os.path.basename(i)[:-len(extantion_fq)]
        for i in os.listdir()
        if i.endswith(extantion_fq)
    ]
    return id_list


# Bulid output folder
os.system("mkdir output")


rule all:
    input:
        expand("{dir}/{sample}.sorted.bam", sample=getidlist(), dir="output"),  #step1 output (bams)
        expand("{dir}/counts_all.txt", dir="output"),  #step2 output (counts)


include: "rules/rnaseq_qc_reads.smk"  #qc1 step
include: "rules/hisat2_alignmaent.smk"  #step1
include: "rules/rnaseq_qc_alignment.smk"  #qc2 step
include: "rules/featureCounts.smk"  #step2
include: "rules/DiffExp.smk"  #step3
include: "rules/visualisation.smk"  #step4
