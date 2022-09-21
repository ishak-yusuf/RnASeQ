rule fastqc:
    input:
        expand(["{dir}/{sample}.fastq.gz"], sample=SAMPLES, dir="output")
    output:
        expand(["{dir}/{sample}.2_fastqc.html"], sample=SAMPLES, dir="output")
    conda:
        "envs/qc.yml"
    params:
        threads = "10"
    shell:
        "fastqc -o {output} -t {params.threads} {input}"

rule multiqc:
    input:
        expand(["{dir}/{sample}_fastqc.html"], sample=SAMPLES, dir="output")
    output:
        expand(["{dir}/multiqc_report.html"], dir="output")
    conda:
        "envs/qc.yml"
    shell:
        "multiqc {input} -o {output} "
