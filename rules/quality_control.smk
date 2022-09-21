rule fastqc:
    input:
        expand(["{dir}/{sample}.fastq.gz"], sample=getidlist(), dir="output")
    output:
        expand(["{dir}/{sample}_fastqc.html"], sample=getidlist(), dir="output")
    conda:
        "envs/qc.yaml"
    params:
        threads = "10"
    shell: "fastqc -o {output} -t {params.threads} {input}"

rule multiqc:
    input:  expand("{dir}/{sample}.fastqc.zip", sample=getidlist(), dir=)
    output:  expand(["{dir}/multiQC.html"], dir="output")
    conda:
        "envs/qc.yaml"
    shell:  'multiqc {input} -n {output}'

rule  seqkit:
    input:  expand("{sample}.fastq.gz", sample=getidlist())
    output: "seq.txt"expand(["{dir}/seqkit_stats.txt"], dir="output")
    threads: 10
    conda: "envs/qc.yaml"
    shell: 'seqkit stats {input} -a -T -j {threads} >> {output} '
