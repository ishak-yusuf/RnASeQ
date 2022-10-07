configfile: "config.yaml"


import os


def getlist_all():
    id_list = []
    for i in os.listdir("input/"):
        # gets list of fastqs:
        if i.endswith(f"{config ['ext'] ['f']}"):
            id = os.path.basename(i)[: -len(f"{config ['ext'] ['f']}")]
            id_list.append(id)
    return id_list

if config["end"] == "paired":
    def getlist_id():
        id_list = []
        for i in os.listdir("input/"):
            # gets list of fastqs:
            if i.endswith(f"{config ['ext'] ['f1']}"):
                id = os.path.basename(i)[: -len(f"{config ['ext'] ['f1']}")]
                id_list.append(id)
        return id_list





include: "rules/quality_control.smk"


if config["map"] == "map_to_ganome":

    rule all:
        input:
            #QC
            expand("QC/{sample}_fastqc.zip", sample=getlist_all()),
            #Step1G_align
            expand("Step1G/{sample}.sorted.bam", sample=getlist_id()),
            #Step2G_assess_align
            expand("Step2G/{sample}.samtoolsflagstat.txt", sample=getlist_id()),
            expand("Step2G/{sample}.r", sample=getlist_id())

    include: "rules/index_genomeG.smk"
    include: "rules/Step1G_align.smk"
    include: "rules/Step2G_assess_align.smk"
    include: "rules/Step3G_featurecount.smk"
    include: "rules/Step4G_diffexp.smk"
    include: "rules/Visualisation.smk"


elif config["map"] == "map_to_transcriptome":
    rule all:
        input:
            #QC
            expand("QC/{sample}_fastqc.zip", sample=getlist_all()),
            #Step1G_align
            expand("Step1G/{sample}.sorted.bam", sample=getlist_all()),
            #Step2G_assess_align
            expand("Step2G/{sample}.samtoolsflagstat.txt", sample=getlist_all()),
            expand("Step2G/{sample}.r", sample=getlist_all())

    include: "rules/index_transT.smk"
    include: "rules/Step1T_align_quant.smk"
    include: "rules/Step2T_diffexp.smk"
    include: "rules/Visualisation.smk"
