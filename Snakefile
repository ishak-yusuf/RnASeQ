configfile: "config.yaml"

import os

def getlist_all():
        id_list=[]
        for i in os.listdir("input/"):
                #gets list of fastqs:
                if i.endswith(f"{config ['ext'] ['f']}"):
                        id = os.path.basename(i)[:-len(f"{config ['ext'] ['f']}")]
                        id_list.append(id)
        return id_list

def getlist_id():
        id_list=[]
        for i in os.listdir("input/"):
                #gets list of fastqs:
                if i.endswith(f"{config ['ext'] ['f1']}"):
                        id = os.path.basename(i)[:-len(f"{config ['ext'] ['f1']}")]
                        id_list.append(id)
        return id_list


rule all:
        input:
            #quiltiy control output
            expand("QC/{sample}_fastqc.zip", sample= getlist_all()),
            "QC/multiqc_report.html",
            "QC/seqkit_stats.txt",
            #STEP1_map_to_genome
            expand("step1/{sample}.sorted.bam", sample= getlist_id()),
            #STEP2_assess_the_alignment
            expand("step2/{sample}.samtools_flagstat.txt", sample= getlist_id()),
            "step2/alignment_rate.csv",
            expand("step2/{sample}.r", sample= getlist_id()),
            "step2/rnaseqc_sheet.csv",
            #STEP3_quantification
            "step3/counts_all.txt"


include: "rules/quality_control.smk"
include: "rules/step1_map_to_genome.smk"
include: "rules/step2_assess_the_alignment.smk"
include: "rules/step3_quantification.smk"
