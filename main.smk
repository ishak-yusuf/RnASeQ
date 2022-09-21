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

# The container has the underlying all tools of the workflow
# with --use-conda --use-singularity
container: "docker://condaforge/mambaforge"

rule all:
    input:
        expand("{dir}/{sample}.sorted.bam", sample=getidlist(), dir="output"),  #step1 output (bams)
        expand("{dir}/counts_all.txt", dir="output"),  #step2 output (counts)


include: "rules/quality_control.smk"
include: "rules/step1_map_to_genome.smk"
include: "rules/step2_assess_the_alignment.smk"
include: "rules/step3_quantification.smk"
include: "rules/step4_different_gene_expression.smk"
include: "rules/step5_visualisation.smk"
