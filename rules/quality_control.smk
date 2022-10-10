rule FastQC:
    output:
        "QC/{sample}_fastqc.zip",
    threads: 1
    params:
        i="input/",
        ext=config["ext"]["f"],
    container:
        "docker://staphb/fastqc"
    shell:
        "fastqc {params.i}{wildcards.sample}{params.ext} -t {threads} -o QC"


rule multiqc:
    input:
        expand("QC/{sample}_fastqc.zip", sample=getlist_all),
    output:
        "QC/multiqc_report.html",
    params:
        "multiqc_report",
    container:
        "docker://staphb/multiqc"
    shell:
        "multiqc {input} -o QC -n {params}"


rule seqkit:
    input:
        expand("input/{sample}{FILE}", sample=getlist_all, FILE=config["ext"]["f"]),
    output:
        "QC/seqkit_stats.txt",
    threads: config["th"]["normal"]
    container:
        "docker://nanozoo/seqkit"
    shell:
        "seqkit stats {input} -a -T -j {threads} >> {output}"
