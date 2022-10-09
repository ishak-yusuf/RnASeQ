configfile: "config.yaml"


import os

# get all fastq files
def getlist_all():
    id_list = [
        os.path.basename(i)[: -len(f"{config ['ext'] ['f']}")]
        for i in os.listdir("input/")
        if i.endswith(f"{config ['ext'] ['f']}")
    ]
    return id_list


# get all id fastq files

if config["end"] == "paired":

    def getlist_id():
        id_list = [
            os.path.basename(i)[: -len(f"{config ['ext'] ['f1']}")]
            for i in os.listdir("input/")
            if i.endswith(f"{config ['ext'] ['f1']}")
        ]
        return id_list

else:
    getlist_id() == getlist_all()


def meta_all():
    newlist = [
        os.path.basename(i)[: -len(".csv")]
        for i in os.listdir("input/meta/")
        if i.endswith(f".csv")
    ]
    return meta


rule QC:
    input:
        #QC
        expand("QC/{sample}_fastqc.zip", sample=getlist_all()),
        "QC/multiqc_report.html",
        "QC/seqkit_stats.txt",


include: "rules/quality_control.smk"


if config["map"] == "Ganome":

    rule ganome:
        input:
            #Step1G_align
            expand("Step1G/{sample}.sorted.bam", sample=getlist_id()),
            #Step2G_assess_align
            expand("Step2G/{sample}.samtoolsflagstat.txt", sample=getlist_id()),
            expand("Step2G/{sample}.r", sample=getlist_id()),
            #Step3G_featurecount
            "Step3G/counts_all.txt",
            #Step4G_diffexp
            expand("Step4G/{sample}_normalised_table.csv", sample=meta_all()),

    include: "rules/index_genomeG.smk"
    include: "rules/Step1G_align.smk"
    include: "rules/Step2G_assess_align.smk"
    include: "rules/Step3G_featurecount.smk"
    include: "rules/Step4G_diffexp.smk"


elif config["map"] == "Transcriptome":

    rule transcriptome:
        input:
            #Step1T_align
            expand("Step1T/{sample}", sample=getlist_id())
            #Step2T_assess_align
            expand("Step2T/{sample}_normalised_table.csv", sample=meta_all()),

    include: "rules/index_transT.smk"
    include: "rules/Step1T_align_quant.smk"
    include: "rules/Step2T_diffexp.smk"
