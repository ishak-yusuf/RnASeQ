configfile: "config.yaml"

import os

def getlist():
        id_list=[]
        for i in os.listdir(f"{config ['idir']}"):
                #gets list of fastqs:
                if i.endswith(f"{config ['eff'] ['f']}"):
                        id = os.path.basename(i)[:-len(f"{config ['eff'] ['f']}")]
                        id_list.append(id)
        return id_list


SAMPLES = getlist()

print(SAMPLES)


rule all:
        input:
            expand("qc/{sample}_fastqc.html", sample=SAMPLES),
            expand("qc/{sample}_fastqc.zip", sample=SAMPLES)

include: "rules/quality_control.smk"