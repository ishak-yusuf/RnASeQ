configfile: "config.yaml"


import os


def getidlist():
    extantion_fq =  config['eff'] ['f1']
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
        Sample=getidlist(),
        #quality control
        expand("{dir}/{sample}.html", sample=Sample, dir="output"),
        expand("{dir}/{sample}_fastqc.zip", sample=Sample, dir="output"),
        expand("{dir}/{sample}.sorted.bam", sample=Sample, dir="output"),
        #stap1
        expand("{dir}/{sample}.sorted.bam", sample=Sample, dir="output"),
        #step2
        expand("{dir}/{sample}samflagstat.txt", sample=Sample, dir="output" ),
        #step3
        expand("{dir}/counts_all.txt", dir="output")



include: "rules/quality_control.smk"
include: "rules/step1_map_to_genome.smk"
include: "rules/step2_assess_the_alignment.smk"
include: "rules/step3_quantification.smk"
include: "rules/step4_different_gene_expression.smk"
include: "rules/step5_visualisation.smk"
