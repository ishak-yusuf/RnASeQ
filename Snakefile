configfile: "config.yaml"


import os

# get all fastq files
getlist_all = [os.path.basename(i)[: -len(f"{config ['ext'] ['f']}")] for i in os.listdir("input/") if i.endswith(f"{config ['ext'] ['f']}")]


# get all id fastq files

if config["end"] == "paired":
    getlist_id = [ os.path.basename(i)[: -len(f"{config ['ext'] ['f1']}")] for i in os.listdir("input/") if i.endswith(f"{config ['ext'] ['f1']}") ]


else:
    getlist_id =  getlist_all.copy()



meta_all = [ os.path.basename(i) for i in os.listdir("input/") if i.endswith(".csv") ]



if config["map"] == "Genome":

    rule Genome:
        input:
            #QC
            expand("QC/{sample}_fastqc.zip", sample= getlist_all ),
            "QC/multiqc_report.html",
            "QC/seqkit_stats.txt",
            #Step1G_align
            expand("Step1G/{sample}.sorted.bam", sample=getlist_id),
            #Step2G_assess_align
            expand("Step2G/{sample}.samtoolsflagstat.txt", sample=getlist_id),
            expand("Step2G/{sample}.r", sample=getlist_id),
            #Step3G_featurecount
            "Step3G/counts_all.txt",
            #Step4G_diffexp
            expand("Step4G/{sample}", sample=meta_all),

    include: "rules/index_genomeG.smk"
    include: "rules/quality_control.smk"
    include: "rules/Step1G_align.smk"
    include: "rules/Step2G_assess_align.smk"
    include: "rules/Step3G_featurecount.smk"
    include: "rules/Step4G_diffexp.smk"


elif config["map"] == "Transcriptome":

    rule Transcriptome:
        input:
            #QC
            expand("QC/{sample}_fastqc.zip", sample=getlist_all()),
            "QC/multiqc_report.html",
            "QC/seqkit_stats.txt",
            #Step1T_align
            expand("Step1T/{sample}", sample=getlist_id()),
            #Step2T_assess_align
            expand("Step2T/{sample}_normalised_table.csv", sample=meta_all()),

    include: "rules/index_transT.smk"
    include: "rules/quality_control.smk"
    include: "rules/Step1T_align_quant.smk"
    include: "rules/Step2T_diffexp.smk"