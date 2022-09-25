
rule FastQC:
    """
    QC on fastq read data
    """
    input:  "input/{sample}.fastq.gz"
    output:
           "qc/{sample}_fastqc.html",
           "qc/{sample}_fastqc.zip"
    threads: 10
    container: "docker://staphb/fastqc"
    shell: 'fastqc {input} -t {threads} -o qc '
''''
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
'''
