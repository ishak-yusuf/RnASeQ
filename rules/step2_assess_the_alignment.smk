#main rules
rule summary_stat:
    input:  "step1/{sample}sorted.bam"
    output: "step2/{sample}samtools_flagstat.txt"
    threads:    10
    container: "docker://condaforge/mambaforge"
    conda: "envs/align.yaml"
    shell: "samtools flagstat {input} -@ {threads} > {output} "


rule RNASeqQC:
    input:  "step1/{sample}sorted.bam"
    params: config ['gtf']
    output: directory("step2/{sample}rnaqc")
    threads: 10
    log: "{sample}rnaqc.log"
    container: "docker://condaforge/mambaforge"
    conda: "envs/rnaseqc.yaml"
    shell:"rnaseqc {params} {input} {output} -d {threads} 2> {log}"

#gathering rules

rule overall_alignment_rate:
        input:  expand("{sample}samb.txt", sample=SAMPLES)
        output: "rate1.csv"
        script: "scripts/Overall_alignment_rate.py"
