configfile: "config.yaml"

import os

def getlist():
        id_list=[]
        for i in os.listdir("input/"):
                #gets list of fastqs:
                if i.endswith(f"{config ['eff'] ['f']}"):
                        id = os.path.basename(i)[:-len(f"{config ['eff'] ['f']}")]
                        id_list.append(id)
        return id_list


SAMPLES = getlist()

print(SAMPLES)

rule all:
        input:
            #quiltiy control output
            expand("qc/{sample}_fastqc.html", sample= SAMPLES),
            expand("qc/{sample}_fastqc.zip", sample= SAMPLES),
            "qc/multiqc_report.html"
            #"seqkit/seqkit_stats.txt"

include: "rules/quality_control.smk"
'''
include: "rules/rnaseq_qc_reads.smk"  #qc1 step
include: "rules/hisat2_alignmaent.smk"  #step1
include: "rules/rnaseq_qc_alignment.smk"  #qc2 step
include: "rules/featureCounts.smk"  #step2
include: "rules/DiffExp.smk"  #step3
include: "rules/visualisation.smk"  #step4
'''
