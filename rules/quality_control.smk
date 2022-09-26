rule FastQC:
    """
    QC on fastq read data
    """
    input: "input/{sample}.fastq.gz"
    output:
           "qc/{sample}_fastqc.html",
           "qc/{sample}_fastqc.zip"
    threads: 5
    container: "docker://staphb/fastqc"
<<<<<<< Updated upstream
    shell: 'fastqc {input} -t {threads} -o qc '
''''
=======
    shell:"""
        fastqc {input} -t {threads} -o qc
        """

>>>>>>> Stashed changes
rule multiqc:
    input:
        expand("qc/{sample}_fastqc.zip", sample= SAMPLES)
    output:
           "qc/multiqc_report.html"
    container: "docker://staphb/multiqc"
    shell: """
        multiqc {input} -o qc
        """

"""
rule  seqkit:
    input:
        expand("input/{sample}.fastq.gz", sample= SAMPLES)
    output:
        "seqkit/seqkit_stats.txt"
    threads: config['th'] ['normal']
    container: "docker://pegi3s/seqkit"
    shell: 'seqkit stats {input} -a -T -j {threads} >> {output} '
<<<<<<< Updated upstream
'''
=======
"""
>>>>>>> Stashed changes
