container: "docker://condaforge/mambaforge"

rule summary_stat:
    input:  "step1/{sample}sorted.bam"
    output: "step2/{sample}samtools_flagstat.txt"
    threads:    10
    container: "docker://condaforge/mambaforge"
    conda: "envs/step2.yaml"
    shell: "samtools flagstat {input} -@ {threads} > {output} "

rule alignment_rate:
        input:  expand("step2/{sample}samtools_flagstat.txt", sample= getlist_id())
        container: "docker://condaforge/mambaforge"
        conda: "envs/step2.yaml"
        output: "step2/alignment_rate.csv"
        script: "scripts/alignment_rate.py"

rule RNASeqQC:
    input:  "step1/{sample}sorted.bam"
    params: config ['gtf']
    output: directory("step2/{sample}rnaqc")
    threads: 10
    log: "{sample}rnaqc.log"
    container: "docker://dceoy/bioconda"
    conda: "envs/rnaseqc.yaml"
    shell:"rnaseqc {params} {input} {output} -d {threads} 2> {log}"

rule rnaseqc_scr:
        input:  expand("step2/{sample}rnaqc/{sample}sorted.bam.metrics.tsv", sample= getlist_id())
        container: "docker://condaforge/mambaforge"
        conda: "envs/step2.yaml"
        output: "step2/rnaseqc_sheet.csv"
        script: "scripts/rnaseqc_sheet.py"




