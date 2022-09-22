
input_area = config['idir']
output_area = config['odir'] ['qc']

rule fastqc:
    input:
        expand(["{dir}/{sample}config['eff'] ['f']]", sample=getidlist(), dir= input_area)
    output:
        expand(["{dir}/{sample}_fastqc.zip"], sample=getidlist(), dir= output_area )
    conda:
        "envs/qc.yaml"
    params:
        threads = config['th'] ['normal']
    shell: "fastqc -o {output} -t {params.threads} {input}"

rule multiqc:
    input:  expand("{dir}/{sample}_fastqc.zip", sample=getidlist(), dir=input_area)
    output:  expand(["{dir}/multiQC.html"], dir= output_area)
    conda:
        "envs/qc.yaml"
    shell:  'multiqc {input} -n {output}'

rule  seqkit:
    input:  expand("{dir}/{sample}.fastq.gz", sample=getidlist(), dir= input_area )
    output: expand(["{dir}/seqkit_stats.txt"], dir= output_area)
    threads: config['th'] ['normal']
    conda: "envs/qc.yaml"
    shell: 'seqkit stats {input} -a -T -j {threads} >> {output} '
