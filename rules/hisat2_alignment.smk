rule hisat2_alignment:
    input:
        f1="{sample}_R1_001.fastq.gz",
        f2="{sample}_R2_001.fastq.gz"
    output:
        "output/{sample}.sorted.bam"
    params:
        ref="genome",
        strandness="FR"
    threads: 48
    message:
        "--- Alignment with Hisat"
    log:
        "output/{sample}.log",
    resources:
        mem_gb=126,
        rate_limit=1,
    conda: "envs/hisat2.yaml"
    shell:
        """
        hisat2 -q --rna-strandness {params.strandness} -x {params.ref} -1 {input.f1} -2 {input.f2} -p {threads} \
        | samtools sort -o {output}
        """