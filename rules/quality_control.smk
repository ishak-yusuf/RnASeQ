rule FastQC:
    """
    QC on fastq read data
    """
    output: "QC/{sample}_fastqc.zip"
    threads: 1
    params: i= "input/",
            ext= config ['ext'] ['f']
    resources:
        mem_gb=16
    message:
        "--- QC with fastqc"
    container: "docker://staphb/fastqc"
    shell:'fastqc {params.i}{wildcards.sample}{params.ext} -t {threads} -o QC'


rule multiqc:
    input: expand("QC/{sample}_fastqc.zip", sample= SAMPLES)
    output:"QC/multiqc_report.html"
    message:
        "--- QC with multiqc"
    container: "docker://staphb/multiqc"
    shell: 'multiqc {input} -o QC'


rule  seqkit:
    input: expand("input/{sample}{FILE}", sample= SAMPLES, FILE= config ['ext'] ['f'])
    output: "QC/seqkit_stats.txt"
    threads: config['th'] ['normal']
    message:
        "--- QC with seqkit "
    container: "docker://nanozoo/seqkit"
    shell: 'seqkit stats {input} -a -T -j {threads} >> {output}'