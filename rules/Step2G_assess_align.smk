container: "docker://condaforge/mambaforge"

rule summary_stat:
    input:
        "Step1G/{sample}.sorted.bam",
    output:
        "Step2G/{sample}.samtoolsflagstat.txt",
    conda:
        "envs/step2.yaml"
    shell:
        "samtools flagstat {input} > {output} "


rule alignment_rate:
    input:
        expand("Step2G/{sample}.samtoolsflagstat.txt", sample=getlist_id),
    conda:
        "envs/step2.yaml"
    output:
        "Step2G/alignment_rate.csv",
    script:
        "scripts/alignment_rate.py"


rule RNASeqQC:
    input:
        "Step1G/{sample}.sorted.bam",
    params:
        config["gtfqc"],
    output:
        directory("Step2G/{sample}.r"),
    threads: config["th"]["normal"]
    log:
        "Step2G/{sample}r.log",
    conda:
        "envs/rnaseqc.yaml"
    shell:
        "rnaseqc {params} {input} {output} -d {threads} 2> {log}"


rule rnaseqc_scr:
    input:
        expand("Step2G/{sample}.r", sample=getlist_id),
    conda:
        "envs/step2.yaml"
    output:
        "Step2G/rnaseqc_sheet.csv",
    script:
        "scripts/rnaseqc_sheet.py"