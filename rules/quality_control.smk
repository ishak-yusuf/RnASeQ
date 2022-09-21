rule FastQC:
    input:
        "{sample}.fastq.gz"
    output:
        html= expand("{dir}/{sample}.html", dir="output")
        zip=  expand("{dir}/{sample}_fastqc.zip", dir="output") 
    params: "--quiet"
    log:
        "logs/fastqc/{sample}.log"
    threads: 1
    wrapper:
        "v1.14.0/bio/fastqc"

