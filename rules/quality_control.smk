rule fastQC:
    """
    QC on fastq read data
    """
    input: "input/{sample}.fastq.gz"
    output: "QC/{sample}_fastqc.zip"
    threads: 1
    container: "docker://staphb/fastqc"
    shell:'fastqc {input} -t {threads} -o QC'

rule multiqc:
    input: expand("QC/{sample}_fastqc.zip", sample= SAMPLES)
    output:"QC/multiqc_report.html"
    container: "docker://staphb/multiqc"
    shell: 'multiqc {input} -o QC'

rule seqkit:
    input: expand("input/{sample}.fastq.gz", sample= SAMPLES)
    output: "QC/seqkit_stats.txt"
    threads: config['th'] ['normal']
    container: "docker://nanozoo/seqkit"
    shell: 'seqkit stats {input} -a -T -j {threads} >> {output} '

