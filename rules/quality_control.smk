import os


def getidlist():
    extantion_fq =  config['eff'] ['f1']
    id_list = [
        os.path.basename(i)[:-len(extantion_fq)]
        for i in os.listdir()
        if i.endswith(extantion_fq)
    ]
    return id_list

print(getidlist())
# Bulid output folder
os.system("mkdir config ['odir'] ['qc']")
input_area = config ['idir']
output_area = config ['odir'] ['qc']

rule fastqc:
    input:
        expand(["{dir}/{sample}config['eff'] ['f']]", sample=getidlist(), dir= input_area)
    output:
        "{output_area}/{sample}_fastqc.zip"
    conda:
        "envs/qc.yaml"
    params:
        threads = config ['th'] ['normal']
    shell: "fastqc -o {output} -t {params.threads} {input}"


rule multiqc:
    input:
        expand("{dir}/{sample}_fastqc.zip", sample= getidlist(), dir=input_area)
    output:
        expand(["{dir}/multiQC.html"], dir= output_area)
    conda:
        "envs/qc.yaml"
    shell:
        'multiqc {input} -n {output}'

rule  seqkit:
    input:  expand("{dir}/{sample}.fastq.gz", sample=getidlist(), dir= input_area )
    output: expand(["{dir}/seqkit_stats.txt"], dir= output_area)
    threads: config['th'] ['normal']
    conda: "envs/qc.yaml"
    shell: 'seqkit stats {input} -a -T -j {threads} >> {output} '
