rule summary_stat:
    input:  "step1/{sample}sorted.bam"
    output: "step2/{sample}samtools_flagstat.txt"
    threads:    10
    container: "docker://condaforge/mambaforge"
    conda: "envs/align.yaml"
    shell: "samtools flagstat {input} -@ {threads} > {output} "

