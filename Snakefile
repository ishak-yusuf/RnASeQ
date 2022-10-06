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


def getlist_id():
    id_list = []
    for i in os.listdir("input/"):
        # gets list of fastqs:
        if i.endswith(f"{config ['ext'] ['f1']}"):
            id = os.path.basename(i)[: -len(f"{config ['ext'] ['f1']}")]
            id_list.append(id)
    return id_list


if config["map"] == "map_to_ganome":

    rule all:
        input:
            #QC
            expand("QC/{sample}_fastqc.zip", sample=getlist_all()),
            #Step1G
            expand("step1/{sample}.sorted.bam", sample=getlist_id()),
            #Step2G
            expand("step2/{sample}.samtools_flagstat.txt", sample=getlist_id()),
            expand("step2/{sample}.r", sample=getlist_id()),

    include: "rules/quality_control.smk"


    if config["index"]:

        include: "rules/genomeG.smk"
    include: "rules/Step1G.smk"
    include: "rules/Step2G.smk"
    include: "rules/Step3G.smk"
    include: "rules/Step4G.smk"
    include: "rules/Visualisation.smk"


elif config["map"] == "map_to_transcriptome":

    rule all:
        input:
            #QC
            expand("QC/{sample}_fastqc.zip", sample=getlist_all()),
            #Step1T
            expand("step1/{sample}.sorted.bam", sample=getlist_id()),
            #Step2T
            expand("step2/{sample}.samtools_flagstat.txt", sample=getlist_id()),
            expand("step2/{sample}.r", sample=getlist_id()),

    include: "rules/quality_control.smk"


    if config["index"]:

        include: "rules/transT.smk"
    include: "rules/Step1T.smk"
    include: "rules/Step2T.smk"
    include: "rules/Visualisation.smk"
