configfile: "config.yaml"

#The container has the underlying all tools of the workflow
# with --use-conda --use-singularity
container: "docker://condaforge/mambaforge"

include: "rules/quality_control.smk"

rule all:
    input:
        Sample=getidlist(),
        #quality control
        expand(["{dir}/{sample}_fastqc.zip"], sample=getidlist(), dir= config ['odir'] ['qc']),
        expand(["{dir}/multiQC.html"], dir= config ['odir'] ['qc']),
        expand(["{dir}/seqkit_stats.txt"], dir= config ['odir'] ['qc']),
        '''
        #stap1
        expand("{dir}/{sample}.sorted.bam", sample=Sample, dir="output"),
        #step2
        expand("{dir}/{sample}samflagstat.txt", sample=Sample, dir="output" ),
        #step3
        expand("{dir}/counts_all.txt", dir="output")
        '''




'''
include: "rules/step1_map_to_genome.smk"
include: "rules/step2_assess_the_alignment.smk"
include: "rules/step3_quantification.smk"
include: "rules/step4_different_gene_expression.smk"
include: "rules/step5_visualisation.smk"
'''