configfile: "config.yaml"


import os


def getlist_all():
    id_list = [os.path.basename(i)[: -len(f"{config ['ext'] ['f']}")] for i in os.listdir("input/") if i.endswith(f"{config ['ext'] ['f']}")]
    return id_list

def getlist_id():
    id_list = [os.path.basename(i)[: -len(f"{config ['ext'] ['f1']}")] for i in os.listdir("input/") if i.endswith(f"{config ['ext'] ['f1']}") ]
    return id_list

def meta_all():
    newlist = [i for i in os.listdir("input/meta/") if i.endswith(f".csv")]
    return meta

rule all:
    input:
        #QC
        expand("QC/{sample}_fastqc.zip", sample=getlist_all()),
        "QC/multiqc_report.html",
        "QC/seqkit_stats.txt",

include: "rules/quality_control.smk"



if config["map"] == "map_to_ganome":

    rule all:
        input:
            #Step1G_align
            expand("Step1G/{sample}.sorted.bam", sample=getlist_id()),
            #Step2G_assess_align
            expand("Step2G/{sample}.samtoolsflagstat.txt", sample=getlist_id()),
            expand("Step2G/{sample}.r", sample=getlist_id()),
            #Step3G_featurecount
            "Step3G/counts_all.txt",
            #Step4G_diffexp
            #Visualisation

    include: "rules/index_genomeG.smk"
    include: "rules/Step1G_align.smk"
    include: "rules/Step2G_assess_align.smk"
    include: "rules/Step3G_featurecount.smk"
    include: "rules/Step4G_diffexp.smk"
    include: "rules/Visualisation.smk"


elif config["map"] == "map_to_transcriptome":

    rule all:
        input:
            #Step1T_align
            #Step2T_assess_align

    include: "rules/index_transT.smk"
    include: "rules/Step1T_align_quant.smk"
    include: "rules/Step2T_diffexp.smk"
    include: "rules/Visualisation.smk"

