configfile: "config.yaml"

import os

def getlist():
        id_list=[]
        for i in os.listdir("input/"):
                #gets list of fastqs:
                if i.endswith(f"{config ['ext'] ['f']}"):
                        id = os.path.basename(i)[:-len(f"{config ['ext'] ['f']}")]
                        id_list.append(id)
        return id_list


SAMPLES = getlist()

rule all:
        input:
            #quiltiy control output
            expand("QC/{sample}_fastqc.zip", sample= SAMPLES),
            "QC/multiqc_report.html",
            "QC/seqkit_stats.txt"


include: "rules/quality_control.smk"
