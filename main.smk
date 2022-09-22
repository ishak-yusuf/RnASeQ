configfile: "config.yaml"

import os

def getlist():
        id_list=[]
        for i in os.listdir("input/"):
                #gets list of fastqs:
                if i.endswith('.fastq.gz'):
                        id = os.path.basename(i)[:-9]
                        id_list.append(id)
        return id_list


SAMPLES = getlist()



os.system('mkdir qc')

rule all:
        input:
            expand("qc/{sample}_fastqc.html", sample=SAMPLES),
            expand("qc/{sample}_fastqc.zip", sample=SAMPLES)

include: "rules/quality_control.smk"