rule hisat2_alignment:
    input:
        f1="{sample}_R1_001.fastq.gz",
        f2="{sample}_R2_001.fastq.gz",
    output:
        "{sample}.sorted.bam",
    params:
        ref="/home/genwork2/Desktop/05.ref_area/ref_hisat2_annhg38p13/GRCh38.p13.genome.fa",
        strandness="FR",
    threads: 10
    message:
        "--- Alignment  with Hisat and samtools"
    log:
        "output/{sample}.log",
    resources:
        mem_gb=15,
        rate_limit=1,
    conda: "envs/align.yaml"
    shell:
        """
        hisat2 -q --rna-strandness {params.strandness} -x {params.ref} -1 {input.f1} -2 {input.f2} -p {threads} |\
        samtools sort -o {output} -@ {threads} 2> {log}
        """
